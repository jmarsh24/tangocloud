export type Track = {
  id: string;
  title: string;
  recordedDate: string;
  orchestra: Orchestra;
  lyricist: Lyricist;
  genre: Genre;
  audioVariants: AudioVariant[];
  singers: Singer[];
  composer: Composer;
  audioFileUrl: string;
  album: Album;
  audioTransfers: AudioTransfer[];
};

export type AudioTransfer = {
  id: string;
  title: string;
  url: string;
  duration: number;
  album: Album;
  audioFileUrl: string;
  audioVariants: AudioVariant[];
};

export type Album = {
  albumArtUrl: string;
  title: string;
  recordedDate: string;
  orchestra: Orchestra;
  lyricist: Lyricist;
  genre: Genre;
  audioVariants: AudioVariant[];
  singers: Singer[];
  composer: Composer;
  url: string;
  id: string;
  tracks: Track[];
};

export type AudioVariant = {
  id: string;
  title: string;
  url: string;
  duration: number;
  album: Album;
  audioFileUrl: string;
};

export type Orchestra = {
  name: string;
};

export type Singer = {
  name: string;
};

export type Composer = {
  name: string;
};

export type Lyricist = {
  name: string;
};

export type Genre = {
  name: string;
};
