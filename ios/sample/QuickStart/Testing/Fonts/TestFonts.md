# Test-only fonts

`NotoSansJP-Regular.ttf` is used in two places:

- TC-CPE-15 checks that Japanese glyphs (`選` → shinjitai `己`, not the Chinese
  `巳`) survive when the host sets a custom font family through
  `SBAFontSet.fontFamily`. The Coupang report was font-specific, so the check
  needs this exact family rather than a system Japanese font.
- Manual QA (AI-338-02) picks it from Font Options in the internal settings
  screen, so internal QuickStart builds carry it in both Debug and Release.

It is **not** part of what ships:

- `public-quickstart.yml` excludes the whole `QuickStart/Testing` directory, so
  the public sample app never sees it.
- `internal-quickstart-spm.yml` and `demo-coupang.yml` exclude
  `QuickStart/Testing` as well.
- `SendbirdAIAgentCore` (the shipped framework) draws its sources from
  `AIAgent/`, which this directory is not part of.

The font is registered at runtime by `TestFontRegistry`, only when something asks
for it:

- `AIAgentMockTestHost`, when a mock UI test launch sets `SBA_AIAGENT_FONT_FAMILY`.
- The internal settings screen (`AppInfoSettingViewController`), when QA picks
  `Noto Sans JP` under Font Options. The segment is disabled in builds that do
  not carry the file.

There is deliberately no `UIAppFonts` entry in `Info.plist` — that would load the
font on every internal QuickStart launch, including ordinary manual runs.

License: SIL Open Font License 1.1 — see `OFL.txt`. Source:
<https://fonts.google.com/noto/specimen/Noto+Sans+JP>.
