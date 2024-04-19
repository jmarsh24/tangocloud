import { StyleSheet, Text, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { defaultStyles } from '@/styles';

const HomeScreen = () => {
    const { colors } = useTheme();

    return (
        <View style={[defaultStyles.container, styles.container]}>
            <Text style={[styles.headerText, { color: colors.text }]}>
                The people who are crazy enough to think they can change the world are the ones who do.
            </Text>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: 20,
    },
    headerText: {
        fontSize: 24,
        fontWeight: 'bold',
        textAlign: 'center',
        marginHorizontal: 20,
        marginVertical: 20,
    }
});

export default HomeScreen;