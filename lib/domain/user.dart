class User{
  late int id;
  late String username;
  late String password;       //Lists with IDs
  late List<int> liked;
  late List<int> favorited;
  late List<int> created;

  User(this.id, this.username, this.password, this.liked, this.favorited, this.created);

  User.defaultUser(){
    id = -1;
    username = "defaultUser";
    password = "defaultPassword";
    liked = [1, 2, 3];
    favorited = [4, 5, 6];
    created = [7, 8, 9];
  }

}