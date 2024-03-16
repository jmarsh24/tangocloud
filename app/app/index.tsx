import React from 'react';
import { Redirect } from 'expo-router';
import { useAuth } from '@/providers/AuthProvider';

const index = () => {
  const { authState } = useAuth();

  if (authState?.authenticated === false) {
    return <Redirect href={'/login'} />;
  }

  return <Redirect href={'/playlists'} />;
};

export default index;