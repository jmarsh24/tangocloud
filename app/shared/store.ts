import { configureStore } from "@reduxjs/toolkit";
import { useEffect, useRef, useState } from "react";
import { DB, MutableDB, reducer, Subscription } from "redux-database";
import { initialState, State } from "./state";

export const store = configureStore({
  reducer: reducer(initialState),
  preloadedState: initialState,
});

export const writeDB = new MutableDB(initialState, { store });
// eslint-disable-next-line @typescript-eslint/no-explicit-any
(globalThis as any).writeDB = writeDB;

// define a hook to force a component to rerender:
export function useForceUpdate(): () => void {
  const [, updateState] = useState(true);
  return () => {
    updateState((state) => !state);
  };
}

export function useDatabase<T>(query: (db: DB<State>) => T): T {
  const forceUpdate = useForceUpdate();
  const subscriptionRef = useRef<Subscription<State, T>>();
  if (!subscriptionRef.current) {
    subscriptionRef.current = writeDB.observe(query);
    subscriptionRef.current.subscribe(() => forceUpdate());
  }
  subscriptionRef.current.query = query;
  useEffect(() => {
    return () => subscriptionRef.current?.cancel();
  }, []);
  return subscriptionRef.current.current;
}
