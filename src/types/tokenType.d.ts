export interface Token {
  kind: string;
  idToken: string;
  refreshToken: string;
  expiresIn: string;
  isNewUser: boolean;
}
