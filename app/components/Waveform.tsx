import React from 'react';
import { View, StyleSheet } from 'react-native';
import Svg, { Rect } from 'react-native-svg';
import MaskedView from '@react-native-masked-view/masked-view';

interface WaveformProps {
  data: number[]; // Array of amplitude values (-1.0 to 1.0)
  width: number; // Width of the waveform container
  height: number; // Height of the waveform container
  strokeColor?: string; // Color of the waveform line for the played part
  progress: number; // Playback progress (0.0 to 1.0)
}

const Waveform: React.FC<WaveformProps> = ({
  data,
  width,
  height,
  strokeColor = '#ff7700',
  progress,
}) => {
  const barWidth = 2;
  const gap = 1;

    if (data.length === 0) {
    return null;
  }

  const numberOfBars = Math.min(data.length, Math.floor(width / (barWidth + gap)));
  const sampledData = sampleData(data, numberOfBars);

  return (
    <MaskedView
      style={{ width, height }}
      maskElement={
        <View style={{ backgroundColor: 'transparent', flex: 1 }}>
          <Svg height="100%" width="100%">
            {sampledData.map((amplitude, index) => {
              const x = index * (barWidth + gap);
              const y = ((1 + amplitude) / 2) * height; // Normalize amplitude to 0-1 and calculate y position
              return (
                <Rect
                  key={index}
                  x={x}
                  y={height - y}
                  width={barWidth}
                  height={y}
                  fill={strokeColor}
                />
              );
            })}
          </Svg>
        </View>
      }
    >
      <View style={{ width: progress * width, height, backgroundColor: strokeColor }} />
    </MaskedView>
  );
};

// Helper function to sample the data array to a manageable number of points
function sampleData(data: number[], samples: number): number[] {
  const step = Math.floor(data.length / samples);
  const sampledData: number[] = [];

  for (let i = 0; i < samples; i++) {
    // Calculate start and end indexes of the current segment
    const start = i * step;
    const end = start + step;

    // Extract the segment
    const segment = data.slice(start, end);

    // Calculate the peak value (maximum absolute value) in this segment
    const peak = segment.reduce((max, current) => Math.max(max, Math.abs(current)), 0);

    sampledData.push(peak);
  }

  return sampledData;
}

const styles = StyleSheet.create({
  // Your styles if needed
});

export default Waveform;