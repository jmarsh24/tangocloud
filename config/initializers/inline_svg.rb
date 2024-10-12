# This fixes this until it's patched https://github.com/jamesmartin/inline_svg/pull/154
InlineSvg.configure do |config|
  config.asset_finder = InlineSvg::PropshaftAssetFinder
end
