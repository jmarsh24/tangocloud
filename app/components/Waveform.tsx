import React from 'react';
import { View, StyleSheet } from 'react-native';
import Svg, { Line } from 'react-native-svg';

type WaveformProps = {
  data: number[]; // Array of amplitude values (0.0 to 1.0)
  width: number; // Width of the waveform container
  height: number; // Height of the waveform container
  strokeColor?: string; // Color of the waveform line for the played part
  remainderStrokeColor?: string; // Color of the waveform line for the remaining part
  strokeWidth?: number; // Width of the waveform line (adjusted to create gaps)
  progress?: number; // Playback progress (0.0 to 1.0)
  gap?: number; // Gap between bars
};

const Waveform: React.FC<WaveformProps> = ({
  data,
  width,
  height,
  strokeColor = '#ff7700',
  remainderStrokeColor = 'white',
  strokeWidth = 1,
  progress = 0,
  gap = 2, // Adjust the gap size if needed
}) => {
  // Adjust barWidth to be smaller than the space allocated for each bar + gap to create visible gaps
  const barWidth = (width - gap * (data.length - 1)) / data.length;
  const effectiveStrokeWidth = Math.max(1, barWidth - gap); // Ensure stroke width is at least 1 and less than the space for each bar

  return (
    <View style={[styles.container, { width, height }]}>
      <Svg height="100%" width="100%">
        {data.map((amplitude, index) => {
          const x = index * (barWidth + gap);
          const y1 = height;
          const y2 = (1 - amplitude) * height;
          const isPlayed = index / data.length < progress;
          return (
            <Line
              key={index}
              x1={x + effectiveStrokeWidth / 2} // Center the line within the allocated space, considering the gap
              y1={y1}
              x2={x + effectiveStrokeWidth / 2} // Same as x1 to make it vertical
              y2={y2}
              stroke={isPlayed ? strokeColor : remainderStrokeColor}
              strokeWidth={effectiveStrokeWidth} // Adjusted stroke width to create gaps
            />
          );
        })}
      </Svg>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default Waveform;