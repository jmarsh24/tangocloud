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
  url: string;
  album: Album;
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
