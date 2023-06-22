import '/exports/exports.dart';
class Routes {
  static String onBoarding = "/onboarding";
  static String login = "/login";
  static String signUp = "/signUp";
  static String home = "/home";
// helper functions
static void routeUntil(BuildContext context, String route){
  Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
}
static void pop(BuildContext context){
  Navigator.of(context).pop();
}

static void named(BuildContext context, String route){
  Navigator.of(context).pushNamed(route);
}
static void push(BuildContext context, Widget widget){
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}
  static Map<String, Widget Function(BuildContext)> routes = {
      Routes.onBoarding: (context) => const Onboarding(),
      Routes.login: (context) =>  const LoginView(),
      Routes.signUp: (context) => const SignUp(),
      Routes.home: (context) => const HomePageView(),
   };
}