class ReelsResponse {
  final List<Document> documents;

  ReelsResponse({required this.documents});

  factory ReelsResponse.fromJson(Map<String, dynamic> json) {
    return ReelsResponse(
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Document {
  final String name;
  final Fields fields;
  final String createTime;
  final String updateTime;

  Document({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'] as String? ?? '',
      fields: Fields.fromJson(json['fields'] as Map<String, dynamic>? ?? {}),
      createTime: json['createTime'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
    );
  }

  String get id => name.split('/').last;
}

class Fields {
  final StringValue caption;
  final StringValue username;
  final IntegerValue likes;
  final StringValue url;

  Fields({
    required this.caption,
    required this.username,
    required this.likes,
    required this.url,
  });

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      caption: StringValue.fromJson(
          json['caption'] as Map<String, dynamic>? ?? {}),
      username: StringValue.fromJson(
          json['username'] as Map<String, dynamic>? ?? {}),
      likes: IntegerValue.fromJson(
          json['likes'] as Map<String, dynamic>? ?? {}),
      url: StringValue.fromJson(json['url'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class StringValue {
  final String stringValue;

  StringValue({required this.stringValue});

  factory StringValue.fromJson(Map<String, dynamic> json) {
    return StringValue(stringValue: json['stringValue'] as String? ?? '');
  }
}

class IntegerValue {
  final int integerValue;

  IntegerValue({required this.integerValue});

  factory IntegerValue.fromJson(Map<String, dynamic> json) {
    return IntegerValue(
      integerValue: int.tryParse(json['integerValue'] as String? ?? '0') ?? 0,
    );
  }
}
