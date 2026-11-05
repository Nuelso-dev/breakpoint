// Alert multiplataforma con la misma API que Alert de React Native.
// En web, Alert.alert de React Native no hace nada (por eso "Cerrar sesión" o
// "Eliminar" no respondían). Aquí se usan los diálogos del navegador.
import { Alert as NativeAlert, Platform } from 'react-native';

function webAlert(title, message, buttons) {
  const text = [title, message].filter(Boolean).join('\n\n');

  if (!buttons || buttons.length === 0) {
    window.alert(text);
    return;
  }

  if (buttons.length === 1) {
    window.alert(text);
    buttons[0]?.onPress?.();
    return;
  }

  const cancel = buttons.find((b) => b.style === 'cancel');
  const confirm = buttons.find((b) => b.style !== 'cancel') ?? buttons[buttons.length - 1];

  if (window.confirm(text)) {
    confirm?.onPress?.();
  } else {
    cancel?.onPress?.();
  }
}

export const Alert = {
  alert: (title, message, buttons, options) => {
    if (Platform.OS === 'web') {
      webAlert(title, message, buttons);
      return;
    }
    NativeAlert.alert(title, message, buttons, options);
  },
};

export default Alert;
