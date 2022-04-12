


abstract class SocialLoginStates{}

class SocialLoginInitialState extends SocialLoginStates{}

class SocialLoginLoadingState extends SocialLoginStates{}

class SocialLoginSuccessState extends SocialLoginStates{
  late final String uId;
  SocialLoginSuccessState(this.uId);

}

class SocialLoginErrorState extends SocialLoginStates{
  final String error;
  SocialLoginErrorState(this.error);
}

class SocialChangePasswordState extends SocialLoginStates{}




