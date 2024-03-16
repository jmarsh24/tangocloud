import React, { useCallback } from 'react';
import { View, StyleSheet, Text, Image, ActivityIndicator, useColorScheme } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { Link } from 'expo-router';
import { USER_PROFILE } from '@/graphql';
import Button from '@/components/Button';
import { FlashList } from "@shopify/flash-list";
import TrackListItem from "@/components/TrackListItem";
import { SafeAreaView } from 'react-native-safe-area-context';
import { useFocusEffect, useTheme } from '@react-navigation/native';

export default function YouScreen() {
  const { authState, onLogout } = useAuth();
  const { colors } = useTheme();

  const { data, loading, error, refetch } = useQuery(USER_PROFILE, {
    skip: !authState.authenticated,
  });

  useFocusEffect(
    useCallback(() => {
      if (authState.authenticated) {
        refetch();
      }
    }, [authState.authenticated, refetch])
  );

  if (!authState.authenticated) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        <Link href='/login' asChild>
          <Button onPress={onLogout} text="Login" />
        </Link>
        <Link href='/register' asChild>
          <Button onPress={onLogout} text="Register" />
        </Link>
      </View>
    );
  }

  if (loading) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        <ActivityIndicator size="large" color={colors.tint} />
      </View>
    );
  }

  if (error) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        <Text style={[styles.text, { color: colors.text }]}>Error loading data...</Text>
        <Button onPress={onLogout} text="Sign out" />
      </View>
    );
  }

  const username = data.userProfile?.username;
  const email = data.userProfile?.email;
  const avatarUrl = data.userProfile?.avatarUrl;
  const recordings = data.userProfile?.playbacks.edges.map((edge) => {
    const recording = edge.node.recording;
    return {
      id: recording.id,
      title: recording.title,
      artist: recording.orchestra?.name || "Unknown Artist",
      duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
      artwork: recording.audioTransfers[0]?.album?.albumArtUrl || "",
      url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || "",
      genre: recording.genre.name,
      year: recording.year,
    };
  });

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.profileContainer}>
        <Image source={{ uri: avatarUrl }} style={styles.image} />
        {username && <Text style={[styles.header, { color: colors.text }]}>{username}</Text>}
        {email && <Text style={[styles.header, { color: colors.text }]}>{email}</Text>}
        <Button onPress={onLogout} text="Sign out" />
      </View>
      <View style={styles.listContainer}>
        <Text style={[styles.header, { color: colors.text }]}>History</Text>
        <FlashList
          data={recordings}
          renderItem={({ item }) => <TrackListItem track={item} />}
          estimatedItemSize={80}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  profileContainer: {
    alignItems: 'center',
    paddingVertical: 20,
  },
  listContainer: {
    flex: 1,
  },
  image: {
    width: 156,
    height: 156,
    borderRadius: 25,
  },
  header: {
    fontSize: 20,
    fontWeight: 'bold',
    marginVertical: 8,
  },
  text: {
    fontSize: 16,
  },
});