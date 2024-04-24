import { forwardRef } from 'react'
import { Pressable, StyleSheet, Text, View } from 'react-native'
import Colors from '../constants/Colors'

type ButtonProps = {
	text: string
} & React.ComponentPropsWithoutRef<typeof Pressable>

const Button = forwardRef<View | null, ButtonProps>(({ text, ...pressableProps }, ref) => {
	return (
		<Pressable ref={ref} {...pressableProps} style={styles.container}>
			<Text style={styles.text}>{text}</Text>
		</Pressable>
	)
})

const styles = StyleSheet.create({
	container: {
		backgroundColor: Colors.light.buttonPrimary,
		padding: 12,
		width: '100%',
		borderRadius: 8,
		flexDirection: 'row',
		justifyContent: 'center',
		alignItems: 'center',
		columnGap: 8,
	},
	text: {
		fontSize: 16,
		fontWeight: '600',
		color: 'white',
	},
})

export default Button
