import 'package:chatapp/Modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthMethods{
  static bool found=true;
final FirebaseAuth _auth =FirebaseAuth.instance;
User _userFromFirebaseUSer(FirebaseUser user)
{
  return user !=null?User(userId:user.uid):null;
}
Future signInWithEmailAndPassword(String email,String password)async{
 try{
   AuthResult result =await _auth.signInWithEmailAndPassword(email: email, password: password);
   FirebaseUser firebaseUser=result.user;
   return _userFromFirebaseUSer(firebaseUser);
 }
 catch(e){
print(e);
 }
}

Future signUpwithEmailAndPassword(String email,String password)async{
  try{
    AuthResult result =await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser firebaseUser=result.user;
    found=true;
    return _userFromFirebaseUSer(firebaseUser);
  }
  catch(e){
    found=false;
  }
}

Future resetpass(String email)async{
  try{
    return await _auth.sendPasswordResetEmail(email: email);
  }
  catch(e){
    print(e);
  }
}

Future signOut()async{
  try{
    return await _auth.signOut();
  }
  catch(e){
    print(e);
  }
}


}