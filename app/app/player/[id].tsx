import React, { useState, useEffect, useRef } from "react";
import {
  StyleSheet,
  View,
  Image,
  Dimensions,
  TouchableWithoutFeedback,
  Alert,
  ActivityIndicator,
  Text,
} from "react-native";
import { useTheme } from "@react-navigation/native";
import TrackPlayer, { useProgress, useIsPlaying } from "react-native-track-player";
import { PlayerControls } from "@/components/PlayerControls";
import { Progress } from "@/components/Progress";
import { TrackInfo } from "@/components/TrackInfo";
import { FETCH_RECORDING } from "@/graphql";
import { useQuery } from "@apollo/client";
import Waveform from "@/components/Waveform";
import * as Sharing from "expo-sharing";
import FontAwesome6 from "react-native-vector-icons/FontAwesome6";
import { useLocalSearchParams } from "expo-router";
import { REMOVE_LIKE_FROM_RECORDING, ADD_LIKE_TO_RECORDING, CHECK_LIKE_STATUS_ON_RECORDING } from "@/graphql";
import { useMutation } from "@apollo/client";
import { Ionicons } from '@expo/vector-icons';
import { ScrollView } from "react-native";

interface Track {
  id: string;
  url: string;
  title: string;
  artist: string;
  artwork: string;
  duration: number;
}

export default function PlayerScreen() {
  const { id } = useLocalSearchParams();
  const vinylRecordImg = require("@/assets/images/vinyl_3x.png");
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const [track, setTrack] = useState<Track | null>(null);
  const { position } = useProgress(1);
  const positionRef = useRef(position);
  const [trackDuration, setTrackDuration] = useState<number>(0);
  const progressRef = useRef(0);
  const animationFrameRef = useRef<number>();
  const deviceWidth = Dimensions.get("window").width;
  const { data, loading, error } = useQuery(FETCH_RECORDING, {
    variables: { id: id },
  });
  const [removeLikeFromRecording] = useMutation(REMOVE_LIKE_FROM_RECORDING);
  const [addLikeToRecording] = useMutation(ADD_LIKE_TO_RECORDING);
  const [isLiked, setIsLiked] = useState(false);
  const { playing, bufferingDuringPlay } = useIsPlaying();

  const { data: likeStatusData, loading: likeStatusLoading, error: likeStatusError } = useQuery(CHECK_LIKE_STATUS_ON_RECORDING, {
    variables: { recordingId: id },
    fetchPolicy: "network-only",
  });

  useEffect(() => {
    if (!likeStatusLoading && likeStatusData) {
      setIsLiked(likeStatusData.checkLikeStatusOnRecording);
    }
  }, [likeStatusData, likeStatusLoading]);

  const handleLike = async () => {
    if (isLiked) {
      await removeLikeFromRecording({
        variables: {
          recordingId: id,
        },
      });
      setIsLiked(false);
    } else {
      await addLikeToRecording({
        variables: {
          recordingId: id,
        },
      });
      setIsLiked(true);
    }
  };

  const loadTrack = async (recordingData) => {
    const trackForPlayer = {
      id: recordingData.id,
      url: recordingData.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
      title: recordingData.title,
      artist: recordingData.orchestra.name,
      artwork: recordingData.audioTransfers[0]?.album?.albumArtUrl,
      duration: recordingData.audioTransfers[0]?.audioVariants[0]?.duration || 0,
    };

    setTrack(trackForPlayer);
    setTrackDuration(trackForPlayer.duration);
    await TrackPlayer.add(trackForPlayer);
    await TrackPlayer.play();
  };

  useEffect(() => {
    const checkAndLoadTrack = async () => {
      try {
        let trackIndex = await TrackPlayer.getActiveTrackIndex();

        if (trackIndex !== null) {
          let trackObject = await TrackPlayer.getTrack(trackIndex);

          if (trackObject === null || trackObject.id !== id) {
            await TrackPlayer.reset();
            await TrackPlayer.pause();

            if (data && data.fetchRecording) {
              await loadTrack(data.fetchRecording);
            }
          } else {
            setTrack(trackObject);
          }
        } else {
          await TrackPlayer.reset();
          await TrackPlayer.pause();

          if (data && data.fetchRecording) {
            await loadTrack(data.fetchRecording);
          }
        }
      } catch (error) {
        console.error("Error loading track:", error);
      }
    };

    checkAndLoadTrack();
  }, [id, data]);

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

  if (loading) {
    return (
      <View>
        <ActivityIndicator size="large" />
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.container}>
        <Text style={styles.errorText}>
          Error loading playlist.
        </Text>
      </View>
    );
  }

  const albumArtUrl = data?.fetchRecording?.audioTransfers[0]?.album?.albumArtUrl || "";
  const waveformData = data?.fetchRecording?.audioTransfers[0]?.waveform?.data || [];
  const lyrics = data?.fetchRecording?.composition?.lyrics[0]?.content || "";
  
  return (
    <ScrollView >
      <View style={styles.container}>
        <View style={[styles.vinyl, { width: vinylSize, height: vinylSize }]}>
          <Image
            source={vinylRecordImg}
            style={[styles.vinylImg, { width: vinylSize, height: vinylSize }]}
          />
          <Image
            source={{ uri: albumArtUrl }}
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
          {track && <TrackInfo track={track} />}
          <Waveform
            data={waveformData}
            width={deviceWidth * 0.92}
            height={50}
            progress={progressRef.current}
          />
          <Progress />
          <View style={styles.row}>
            <TouchableWithoutFeedback onPress={shareRecording}>
              <FontAwesome6 name={"share"} size={30} style={styles.icon} />
            </TouchableWithoutFeedback>
            <Ionicons
              onPress={handleLike}
              name={isLiked ? 'heart' : 'heart-outline'}
              size={36}
              color={colors.text}
              style={{ marginHorizontal: 10 }}
            />
          </View>
          <PlayerControls />
        </View>
        <View style={styles.lyricsContainer}>
          <Text style={styles.lyricsText}>
            {lyrics}
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}

function getStyles(colors) {
  return StyleSheet.create({
    container: {
      padding: 20,
      alignItems: "center",
      backgroundColor: colors.background,
    },
    subtitle: {
      color: colors.text,
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
      color: colors.text,
    },
    artist: {
      fontSize: 18,
      color: colors.text,
    },
    controls: {
      display: "flex",
      alignItems: "center",
      gap: 20,

    },
    playButtonContainer: {
      backgroundColor: colors.buttonSecondary,
      borderRadius: 35,
      width: 70,
      height: 70,
      justifyContent: "center",
      alignItems: "center",
    },
    icon: {
      color: colors.text,
    },
    lyricsContainer: {
      marginTop: 20,
      paddingHorizontal: 20,
      paddingBottom: 80
    },
    lyricsText: {
      fontSize: 16,
      lineHeight: 24,
      fontWeight: "600",
      textAlign: 'center',
      color: colors.text,
    },
  });
}