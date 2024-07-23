import React from 'react';
import { View } from 'react-native';
import Svg, { Rect } from 'react-native-svg';
import MaskedView from '@react-native-masked-view/masked-view';
import { useTheme } from '@react-navigation/native';

interface WaveformProps {
  data: number[];
  width: number;
  height: number;
  strokeColor?: string;
  progress: number;
}

const Waveform: React.FC<WaveformProps> = ({
  data,
  width,
  height,
  strokeColor = '#ff7700',
  progress,
}) => {
  const { colors } = useTheme();
  const barWidth = 2;
  const gap = 1;
  const waveformBaseColor = colors.text;

  const numberOfBars = Math.floor(width / (barWidth + gap));
  const sampledData = React.useMemo(
    () => sampleData(data, Math.min(data.length, numberOfBars)),
    [data, numberOfBars]
  );

  if (data.length === 0) {
    return null;
  }

  const renderWaveformBars = (color: string, opacity: number = 1, inverted: boolean = false) => (
    <Svg height="100%" width="100%">
      {sampledData.map((amplitude, index) => {
        const x = index * (barWidth + gap);
        const barHeight = ((1 + amplitude) / 2) * height;
        const y = inverted ? 1 : height - barHeight;
        return (
          <Rect
            key={`${index}${inverted ? 'i' : ''}`}
            x={x}
            y={y}
            width={barWidth}
            height={inverted ? barHeight / 2 : barHeight}
            fill={color}
            fillOpacity={opacity}
          />
        );
      })}
    </Svg>
  );

  return (
    <View style={{ width, height, position: 'relative' }}>
      <View style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%' }}>
        {renderWaveformBars(waveformBaseColor, 0.7)}
        {renderWaveformBars(waveformBaseColor, 0.7, true)}
      </View>

      <MaskedView
        style={{ width, height }}
        maskElement={
          <View style={{ backgroundColor: 'transparent', flex: 1 }}>
            {renderWaveformBars(strokeColor, 0.7)}
            {renderWaveformBars(strokeColor, 0.7, true)}
          </View>
        }
      >
        <View style={{ width: progress * width, height, backgroundColor: strokeColor }} />
      </MaskedView>
    </View>
  );
};

function sampleData(data: number[], samples: number, exaggerationFactor: number = 2): number[] {
  const step = Math.floor(data.length / samples);
  const sampledData: number[] = [];

  for (let i = 0; i < samples; i++) {
    const start = i * step;
    const end = start + step;
    const segment = data.slice(start, end);
    let peak = segment.reduce((max, current) => Math.max(max, Math.abs(current)), 0);

    peak = Math.pow(peak, exaggerationFactor);

    sampledData.push(peak);
  }

  return sampledData;
}

export default Waveform;