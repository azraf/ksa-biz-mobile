import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/repositories.dart';

Future<dynamic> showQuickCreateCustomerSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String customerType,
  required int? salesPersonId,
}) {
  final offlineSalesPersonId = requireSalesPersonId(ref.read(authProvider));
  return core.showQuickCreateCustomerSheet(
    context: context,
    host: core.QuickCreateCustomerHost(
      customerRepository: ref.read(customerRepositoryProvider),
      isOnline: () => ref.read(onlineStatusProvider),
      attachShopPhoto: (file, shopId) =>
          ref.read(mediaCaptureFacadeProvider).attachShopPhoto(file, shopId),
      createOfflineProspect: offlineSalesPersonId == null
          ? null
          : ({required gps, placeName, noteText, phone, photoFile}) async {
              final item = await ref.read(offlineWatchlistRepositoryProvider).create(
                    gps: gps,
                    salesPersonId: offlineSalesPersonId,
                    placeName: placeName,
                    noteText: noteText,
                    phone: phone,
                  );
              if (photoFile != null) {
                await ref.read(mediaCaptureFacadeProvider).attachWatchlistGallery(
                      photoFile,
                      item.id,
                      localId: item.isLocalOnly ? item.id : null,
                    );
              }
            },
    ),
    customerType: customerType,
    salesPersonId: salesPersonId,
  );
}
