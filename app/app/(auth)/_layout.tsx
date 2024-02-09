import { useAuth } from '@/providers/AuthProvider';
import { Redirect, Stack } from 'expo-router';

export default function AuthLayout() {
  const { authState } = useAuth();

  if (authState?.authenticated === true) {
    return <Redirect href={'/'} />;
  }

  return <Stack />;
}