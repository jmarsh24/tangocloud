import React from 'react'
import { Image, StyleSheet } from 'react-native'
import MaterialIcons from '@expo/vector-icons/MaterialIcons'

interface AvatarProps {
  avatarUrl?: string
  size?: number
}

const Avatar: React.FC<AvatarProps> = ({ avatarUrl, size = 36 }) => {
  return avatarUrl ? (
    <Image source={{ uri: avatarUrl }} style={[styles.avatar, { width: size, height: size, borderRadius: size / 2 }]} />
  ) : (
    <MaterialIcons name="person" size={size} />
  )
}

const styles = StyleSheet.create({
  avatar: {
    width: 36,
    height: 36,
    borderRadius: 18,
  },
})

export default Avatar
