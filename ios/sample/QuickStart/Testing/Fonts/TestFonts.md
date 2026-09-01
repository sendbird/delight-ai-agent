# Test-only fonts

`NotoSansJP-Regular.ttf` exists for one reason: TC-CPE-15 checks that Japanese
glyphs (`選` → shinjitai `己`, not the Chinese `巳`) survive when the host sets a
custom font family through `SBAFontSet.fontFamily`. The Coupang report was
font-specific, so the check needs this exact family rather than a system
Japanese font.

It is **not** part of what ships:

- `public-quickstart.yml` excludes the whole `QuickStart/Testing` directory, so
  the public sample app never sees it.
- The internal QuickStart target sets `EXCLUDED_SOURCE_FILE_NAMES` for the
  Release config, so release builds drop it too.
- `SendbirdAIAgentCore` (the shipped framework) draws its sources from
  `AIAgent/`, which this directory is not part of.

The font is registered at runtime by `AIAgentMockTestHost`, only when a mock UI
test launch asks for it via `SBA_AIAGENT_FONT_FAMILY`. There is deliberately no
`UIAppFonts` entry in `Info.plist` — that would load the font on every internal
QuickStart launch, including ordinary manual runs.

License: SIL Open Font License 1.1 — see `OFL.txt`. Source:
<https://fonts.google.com/noto/specimen/Noto+Sans+JP>.
