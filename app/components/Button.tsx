import { colors } from '@/constants/tokens'
import { forwardRef } from 'react'
import { Pressable, StyleSheet, Text, View } from 'react-native'

type ButtonProps = {
	text: string
	type?: 'primary' | 'secondary'
} & React.ComponentPropsWithoutRef<typeof Pressable>

const Button = forwardRef<View | null, ButtonProps>(
	({ text, type = 'primary', ...pressableProps }, ref) => {
		return (
			<Pressable
				ref={ref}
				{...pressableProps}
				style={[styles.container, type === 'secondary' ? styles.secondary : styles.primary]}
			>
				<Text style={styles.text}>{text}</Text>
			</Pressable>
		)
	},
)

const styles = StyleSheet.create({
	container: {
		paddingVertical: 8,
		paddingHorizontal: 16,
		borderRadius: 8,
		flexDirection: 'row',
		justifyContent: 'center',
	},
	primary: {
		backgroundColor: colors.primary,
	},
	secondary: {
		backgroundColor: 'transparent',
		borderWidth: 2,
		borderRadius: 24,
		borderColor: 'rgba(255, 255, 255, 0.2)',
	},
	text: {
		fontSize: 16,
		fontWeight: '600',
		color: 'white',
	},
})

export default Button
