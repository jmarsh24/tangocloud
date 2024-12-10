const { userAgent } = window.navigator;

export const isIos = /iPhone|iPad/i.test(userAgent);
export const isAndroid = /Android/i.test(userAgent);
export const isMobile = isIos || isAndroid;

export const isDesktop = !isMobile;