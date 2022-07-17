import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/src/utils/text_styles.dart';

enum KSymbolType { Bullet, Numbered, Custom }

/// Add UL to its children
class KUL extends StatelessWidget {
  final List<Widget>? children;
  final double padding;
  final double spacing;
  final KSymbolType symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? edgeInsets;
  final Widget? customSymbol;
  final String? prefixText; // Used when SymbolType is Numbered

  KUL({
    this.children,
    this.padding = 8,
    this.spacing = 8,
    this.symbolType = KSymbolType.Bullet,
    this.symbolColor,
    this.textColor,
    this.customSymbol,
    this.prefixText,
    this.edgeInsets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.validate().length, (index) {
        return Container(
          padding: edgeInsets ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // crossAxisAlignment: symbolType == KSymbolType.Numbered
            //     ? CrossAxisAlignment.start
            //     : CrossAxisAlignment.center,
            children: [
              symbolType == KSymbolType.Bullet
                  ? Text(
                '•',
                style: boldTextStyle(
                    color: textColor ?? textPrimaryColorGlobal, size: 24),
              )
                  : SizedBox(),
              symbolType == KSymbolType.Numbered
                  ? Text('${prefixText.validate()} ${index + 1}.',
                  style: boldTextStyle(
                      color: symbolColor ?? textPrimaryColorGlobal))
                  : SizedBox(),
              (symbolType == KSymbolType.Custom && customSymbol != null)
                  ? customSymbol!
                  : SizedBox(),
              SizedBox(width: padding),
              children![index].expand(),
            ],
          ),
        );
      }),
    );
  }
}
