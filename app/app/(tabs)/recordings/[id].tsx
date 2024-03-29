import React, { useState, useEffect, useRef } from "react";
import {
  StyleSheet,
  View,
  Image,
  Dimensions,
  TouchableWithoutFeedback,
  Alert,
} from "react-native";
import { useTheme } from "@react-navigation/native";
import TrackPlayer, { useProgress } from "react-native-track-player";
import { PlayerControls } from "@/components/PlayerControls";
import { Progress } from "@/components/Progress";
import { TrackInfo } from "@/components/TrackInfo";
import { FETCH_RECORDING } from "@/graphql";
import { useQuery } from "@apollo/client";
import Waveform from "@/components/Waveform";
import * as Sharing from "expo-sharing";
import FontAwesome6 from "react-native-vector-icons/FontAwesome6";
import { useLocalSearchParams } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";

export default function RecordingScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const vinylRecordImg = require("@/assets/images/vinyl_3x.png");
  const { colors } = useTheme();
  const [track, setTrack] = useState<any>(null);
  const { position } = useProgress(1);
  const positionRef = useRef(position);
  const [trackDuration, setTrackDuration] = useState<number>(0);
  const progressRef = useRef(0);
  const animationFrameRef = useRef<number>();
  const deviceWidth = Dimensions.get("window").width;
  const { data, loading, error } = useQuery(FETCH_RECORDING, { variables: { id: id } });
  const waveformData = data?.fetchRecording?.audioTransfers[0]?.waveform?.data || [];

  useEffect(() => {
    if (error) {
      console.error("Error fetching recording:", error);
    }
  }, [error]);

  useEffect(() => {
    const loadTrack = async () => {
      if (data && data.fetchRecording) {
        const recordingData = data.fetchRecording;

        const trackForPlayer = {
          id: recordingData.id,
          url: recordingData.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
          title: recordingData.title,
          artist: recordingData.orchestra.name,
          artwork: recordingData.audioTransfers[0]?.album?.albumArtUrl,
          duration: recordingData.audioTransfers[0]?.audioVariants[0]?.duration,
        };

        try {
          await TrackPlayer.reset();
          await TrackPlayer.add(trackForPlayer);
          setTrack(trackForPlayer);
          await TrackPlayer.play();
        } catch (error) {
          console.error("Error playing track:", error);
        }
      }
    };

    loadTrack();
  }, [id]);

  useEffect(() => {
    positionRef.current = position;
  }, [position]);

  useEffect(() => {
    const animateProgress = () => {
      const newProgress =
        trackDuration > 0 ? positionRef.current / trackDuration : 0;
      progressRef.current = newProgress;
      animationFrameRef.current = requestAnimationFrame(animateProgress);
    };

    animateProgress();

    return () => {
      if (animationFrameRef.current)
        cancelAnimationFrame(animationFrameRef.current);
    };
  }, [trackDuration]);

  const screenWidth = Dimensions.get("window").width;
  const vinylSize = screenWidth * 0.8;
  const albumArtSize = vinylSize * 0.36;

  const shareRecording = async () => {
    const url = `https://tangocloud.app/recordings/${id}`;
    const isAvailable = await Sharing.isAvailableAsync();
    if (isAvailable) {
      try {
        await Sharing.shareAsync(url);
      } catch (error) {
        console.log(error);
        Alert.alert("Error", "Failed to share the recording.");
      }
    } else {
      Alert.alert("Unavailable", "Sharing is not available on this device.");
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={[styles.vinyl, { width: vinylSize, height: vinylSize }]}>
        <Image
          source={vinylRecordImg}
          style={[styles.vinylImg, { width: vinylSize, height: vinylSize }]}
        />
        <Image
          source={{
            uri: data?.fetchRecording?.audioTransfers[0]?.album
              ?.albumArtUrl,
          }}
          style={[
            styles.albumArt,
            {
              width: albumArtSize,
              height: albumArtSize,
              borderRadius: albumArtSize / 2,
              top: (vinylSize - albumArtSize) / 2,
              left: (vinylSize - albumArtSize) / 2,
            },
          ]}
        />
      </View>
      <View style={styles.controls}>
        <TrackInfo track={track} />
        <Waveform
          data={waveformData}
          width={deviceWidth * 0.92}
          height={50}
          progress={progressRef.current}
        />
        <Progress />
        <TouchableWithoutFeedback onPress={shareRecording}>
          <FontAwesome6 name={"share"} size={30} style={styles.icon} />
        </TouchableWithoutFeedback>
        <PlayerControls />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: 20,
  },
  subtitle: {
    fontSize: 12,
  },
  row: {
    display: "flex",
    gap: 10,
    flexDirection: "row",
    alignItems: "center",
  },
  vinylImg: {
    position: "absolute",
    justifyContent: "center",
    alignItems: "center",
  },
  albumArt: {
    position: "absolute",
    justifyContent: "center",
    alignItems: "center",
    zIndex: 2,
  },
  trackInfo: {
    alignItems: "center",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
  },
  artist: {
    fontSize: 18,
  },
  controls: {
    display: "flex",
    alignItems: "center",
    gap: 20,
  },
  playButtonContainer: {
    borderRadius: 35,
    width: 70,
    height: 70,
    justifyContent: "center",
    alignItems: "center",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
});