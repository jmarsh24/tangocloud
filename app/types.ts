export type Track = {
  id: string;
  title: string;
  recordedDate: string;
  albumArtUrl: string;
  orchestra: Orchestra;
  lyricist: Lyricist;
  genre: Genre;
  audios: Audio[];
  singers: Singer[];
  composer: Composer;
};

export type Audio = {
  id: string;
  title: string;
  url: string;
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
