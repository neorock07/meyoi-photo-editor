part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;  
  static const BOTTOM_NAV = _Paths.BOTTOM_NAV;  
  static const COBA = _Paths.COBA;  
  static const WELCOME = _Paths.WELCOME;  
  static const REGISTER = _Paths.REGISTER;  
  static const LOGIN = _Paths.LOGIN;  
  static const EDIT = _Paths.EDIT;  
  static const LOADING = _Paths.LOADING;  
  static const TERMS = _Paths.TERMS;  
  static const IMAGE_DETAIL = _Paths.IMAGE_DETAIL;  
  static const HISTORY = _Paths.HISTORY;  
  static const FORGOT = _Paths.FORGOT;  
  static const FAQ = _Paths.FAQ;  
}

abstract class _Paths{
  static const SPLASH = '/splash';
  static const BOTTOM_NAV = '/nav';
  static const HOME = '/home';
  static const WELCOME = '/welcome';
  static const REGISTER = '/register';
  static const LOGIN = '/login';
  static const EDIT = '/edit';
  static const LOADING = '/loading_image';
  static const TERMS = '/terms';
  static const FORGOT = '/forgot';
  static const IMAGE_DETAIL = '/image_detail';
  static const HISTORY = '/history';
  static const FAQ = '/faq';
  static const COBA = '/coba';
}