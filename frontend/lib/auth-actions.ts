import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  sendPasswordResetEmail,
  signOut as firebaseSignOut,
  UserCredential,
  onAuthStateChanged,
  User
} from 'firebase/auth';
import { auth } from './firebase';

export type AuthResult = {
  success: boolean;
  error?: string;
  user?: User;
};

export async function signInWithEmail(email: string, password: string): Promise<AuthResult> {
  try {
    const userCredential: UserCredential = await signInWithEmailAndPassword(auth, email, password);
    return { success: true, user: userCredential.user };
  } catch (error: any) {
    return {
      success: false,
      error: getErrorMessage(error.code)
    };
  }
}

export async function signUpWithEmail(email: string, password: string): Promise<AuthResult> {
  try {
    const userCredential: UserCredential = await createUserWithEmailAndPassword(auth, email, password);
    return { success: true, user: userCredential.user };
  } catch (error: any) {
    return {
      success: false,
      error: getErrorMessage(error.code)
    };
  }
}

export async function resetPassword(email: string): Promise<AuthResult> {
  try {
    await sendPasswordResetEmail(auth, email);
    return { success: true };
  } catch (error: any) {
    return {
      success: false,
      error: getErrorMessage(error.code)
    };
  }
}

export async function signOutFirebase(): Promise<void> {
  await firebaseSignOut(auth);
}

export async function getIdToken(): Promise<string | null> {
  const user = auth.currentUser;
  if (user) {
    return user.getIdToken();
  }
  return null;
}

export function onAuthChange(callback: (user: User | null) => void) {
  return onAuthStateChanged(auth, callback);
}

function getErrorMessage(code: string): string {
  switch (code) {
    case 'auth/email-already-in-use':
      return 'Dit e-mailadres is al in gebruik.';
    case 'auth/invalid-email':
      return 'Ongeldig e-mailadres.';
    case 'auth/operation-not-allowed':
      return 'E-mail/wachtwoord login is niet ingeschakeld.';
    case 'auth/weak-password':
      return 'Wachtwoord moet minimaal 6 tekens bevatten.';
    case 'auth/user-disabled':
      return 'Dit account is uitgeschakeld.';
    case 'auth/user-not-found':
      return 'Geen account gevonden met dit e-mailadres.';
    case 'auth/wrong-password':
      return 'Onjuist wachtwoord.';
    case 'auth/invalid-credential':
      return 'Ongeldige inloggegevens.';
    case 'auth/too-many-requests':
      return 'Te veel pogingen. Probeer het later opnieuw.';
    default:
      return 'Er is een fout opgetreden. Probeer het opnieuw.';
  }
}
