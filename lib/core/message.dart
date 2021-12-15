class Message {
  final String message;
  final MessageType type;
  final String? extraInfo;

  Message({required this.message, this.type = MessageType.error, this.extraInfo});

  Message.error(this.message, {this.extraInfo}) : this.type = MessageType.error;

  Message.warning(this.message, {this.extraInfo}) : this.type = MessageType.warning;

  Message.success(this.message, {this.extraInfo}) : this.type = MessageType.success;

  Message.info(this.message, {this.extraInfo}) : this.type = MessageType.info;
}

enum MessageType { error, warning, success, info }
