import { colors } from '@/constants/tokens'
import { useEffect, useState } from 'react'
import { getColors } from 'react-native-image-colors'
import { ImageColorsResult } from 'react-native-image-colors/lib/typescript/types'
import tinycolor from 'tinycolor2'

export const usePlayerBackground = (imageUrl: string) => {
	const [imageColors, setImageColors] = useState<ImageColorsResult | null>(null)
	const [readablePrimaryColor, setReadablePrimaryColor] = useState('')

	useEffect(() => {
		getColors(imageUrl, {
			fallback: colors.background,
			cache: true,
			key: imageUrl,
		}).then((result) => {
			setImageColors(result)
			let primaryColor
			if (result.platform === 'android') {
				primaryColor = result.dominant
			} else if (result.platform === 'ios') {
				primaryColor = result.primary
			}

			if (primaryColor) {
				let modifiedColor = tinycolor(primaryColor)
				// Check if the color is not optimal for readability against both black and white
				if (!isReadableAgainstBlackAndWhite(modifiedColor)) {
					// Adjust color by making it either darker or lighter
					modifiedColor = adjustColorForReadability(modifiedColor)
				}
				setReadablePrimaryColor(modifiedColor.toString())
			}
		})
	}, [imageUrl])

	return { imageColors, readablePrimaryColor }
}

function isReadableAgainstBlackAndWhite(color) {
	const white = tinycolor('#fff')
	const black = tinycolor('#000')
	return tinycolor.readability(color, white) > 3.5 && tinycolor.readability(color, black) > 3.5
}

function adjustColorForReadability(color) {
	if (color.isLight()) {
		return color.darken(15)
	} else {
		return color.lighten(15)
	}
}
