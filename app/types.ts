export type Track = {
  id: string;
  title: string;
  orchestra: Orchestra;
  singer: Singer;
  alubm: Album;
  genre: Genre;
  audios: Audio[];
  recording_date: string;
};
export type Album = {
  id: string;
  name: string;
};
export type Audio = {
  title: string;
  length: number;
  fileUrl: string;
};
export type Orchestra = {
  name: string;
};
export type Singer = {
  name: string;
};
export type Genre = {
  name: string;
};
// export type Artist = {
//   id: string;
//   name: string;
//   images?: Image[];
// };

// export type Image = {
//   url: string;
//   height?: number;
//   width?: number;
// };
