part of 'comment_bloc.dart';

abstract class CommentEvent {}

class CommentInitializeEvent extends CommentEvent {
  String productID;
  CommentInitializeEvent(this.productID);
}

class CommentPostEvent extends CommentEvent {
  String comment;
  String productId;
  CommentPostEvent(this.comment, this.productId);
}
