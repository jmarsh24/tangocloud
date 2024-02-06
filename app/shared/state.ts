export interface State {
  settings: {
    accessToken: string | null;
  };
  // eslint-disable-next-line @typescript-eslint/ban-types
  data: {};
}

export const initialState: State = {
  data: {},
  settings: {
    accessToken: null,
  },
};
