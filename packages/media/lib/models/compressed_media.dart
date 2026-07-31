import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class CompressedMedia extends Equatable {
  const CompressedMedia({
    required this.localPath,
    required this.mimeType,
    required this.kind,
    required this.originalBytes,
    required this.compressedBytes,
    this.originalName,
  });

  final String localPath;
  final String mimeType;
  final MediaKind kind;
  final int originalBytes;
  final int compressedBytes;
  final String? originalName;

  double get compressionRatio =>
      originalBytes == 0 ? 1 : compressedBytes / originalBytes;

  @override
  List<Object?> get props => [localPath, mimeType, kind, compressedBytes];
}
