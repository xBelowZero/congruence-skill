---
name: congruence
description: Verwenden Sie diese Skill immer dann, wenn Sie kurz davor sind, Arbeit als abgeschlossen zu erklären, einen Commit zu machen, einen PR zu öffnen, README/CHANGELOG/Docs zu aktualisieren oder eine Änderung auszuliefern, die nutzerseitigen Text betrifft — auditiert, ob das, was der Agent gesagt, geschrieben oder dokumentiert hat, tatsächlich mit dem übereinstimmt, was der Code tut. Proaktiv vor JEDER Fertigstellungs-Behauptung verwenden. AUSLÖSEN wenn der Agent Phrasen wie "unterstützt jetzt", "implementiert", "funktioniert", "fertig", "behoben", "hinzugefügt" verwendet; wenn geänderte Dateien README, CHANGELOG, docs/, help-center, FAQ, Landing Pages, UI-Copy oder KI-Prompts beinhalten; vor Release/Deploy. ÜBERSPRINGEN wenn Änderungen nur Formatierung sind, Dependency-Version-Bumps, interne Refactors ohne nutzerseitigen Text-Touch oder reine Test-Datei-Änderungen.
argument-hint: [scope?] [--dispatch-agent?]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(scripts/scan-changed-files.sh:*), Task
---

# Congruence

Auditiert, ob das, was der Agent gesagt, geschrieben oder dokumentiert hat, dem entspricht, was der Code tatsächlich tut. **Dies ist kein technisches Code Review.** Es ist ein Audit der **semantischen Wahrheit**.

**Kernprinzip:** Keine Behauptung über das Projekt ist wahr ohne Beweis im Projekt selbst.

**Den Buchstaben dieser Regel zu verletzen heißt, ihren Geist zu verletzen.** Text, den der Agent gerade generiert hat, ist niemals eine Wahrheitsquelle — auch nicht mit Einschränkungen wie "wahrscheinlich", "sollte sein", "ich nahm an, dass".

## Das Iron Law

```
KEINE NUTZERSEITIGE BEHAUPTUNG OHNE GROUND-TRUTH-BEWEIS
```

Wenn Sie geschrieben haben "die App macht jetzt X" und Sie nicht auf die Datei/den Test/die Route zeigen können, die X beweist, dürfen Sie diese Behauptung **nicht** veröffentlichen. Stufen Sie sie herab zu "geplant"/"teilweise" oder entfernen Sie sie.

## Gate Function — vor jeder Behauptung oder Doc-Bearbeitung

Reihenfolge einhalten. Jeder Schritt blockiert den nächsten, wenn unvollständig.

1. **EXTRAHIEREN** — Listen Sie jede konkrete Behauptung im Output ("unterstützt X", "ich habe Y behoben", "zeigt jetzt Z an"). Siehe [references/claim-extraction-guide.md](references/claim-extraction-guide.md), falls Sie Techniken brauchen.
2. **MAPPEN** — Zeigen Sie für jede Behauptung auf Datei:Zeile/Test/Route, die sie beweist. Kein Ziel? Markieren Sie als `nicht überprüfbar`.
3. **AUDITIEREN** — Für jede unbewiesene Behauptung: **löschen** oder **herabstufen** auf "geplant/teilweise/in Arbeit".
4. **CROSS-CHECK** — Stellen Sie sicher, dass die Terminologie in Docs mit dem Code übereinstimmt (Funktionsnamen, Env-Vars, Routen, Labels).
5. **AUSGEBEN** — Erst jetzt generieren Sie die Nachricht/Commit/PR/Release Notes.

## Beweistabelle nach Behauptungstyp

| Behauptung | Erfordert | Nicht ausreichend |
|------------|-----------|-------------------|
| "Unterstützt jetzt X" | Passierender Test + grep-barer Funktions-/Routenname | "Ich habe einen TODO hinzugefügt", "Scaffolding existiert" |
| "Bug Y behoben" | Roter Test → Grüner Test (red-green) | "Code geändert, sieht korrekt aus" |
| "README sagt X" | grep README + grep Code, beide enthalten X | nur README-Bearbeitung |
| "Y in Z umbenannt" | grep ganzes Repo: 0 Vorkommen von Y | in 1 Datei umbenannt |
| "Feature W entfernt" | grep Code + README + Tests → 0 Vorkommen | nur aus Code entfernt |
| "Integriert mit Stripe/X" | Code + Env-Var + Handler/Webhook konfiguriert | mock oder `// TODO: Stripe integrieren` |
| "Preis/Datum/Zahl X" | grep des literalen Werts im Source (config, db seed, oder hartkodiert) | Zahl erscheint nur in generierter Copy |
| "Hat X Optionen im Select" | Komponente listet exakt X Items, nicht mock | "sollte etwa X Optionen haben" |

Tiefergehender Guide: [references/source-of-truth-priority.md](references/source-of-truth-priority.md)

## Red Flags — STOP

Wenn Sie sich beim Denken oder Schreiben ertappen:

- "sollte funktionieren", "ist wahrscheinlich", "ich nahm an, dass", "es ist implizit"
- README **vor** dem Code schreiben (oder danach, ohne den Code erneut zu lesen)
- LLM-generierte PR-Beschreibung ohne grep einfügen
- "Ich werde X in den Docs erwähnen, der User findet die genaue Schreibweise"
- Funktion umbenennen ohne grep im ganzen Repo
- Status-Report enthält ein Feature, das "früher in der Session" implementiert wurde, ohne erneut zu verifizieren
- `package.json`/`README` beschreiben etwas anderes als der Entry-Point tatsächlich tut
- Marketing-/Landing-Copy verspricht einen Benefit ohne Code dahinter

→ STOP. Zurück zu Schritt 1 der Gate Function.

## Tabelle Ausrede | Realität

| Ausrede | Realität |
|---------|----------|
| "Der User korrigiert das README später" | Eine veröffentlichte Behauptung = eine gemachte Behauptung. Verifizieren oder entfernen. |
| "Nah genug" | Nah ≠ wahr. Code ist binär, Behauptung auch. |
| "Es sind nur Docs" | Docs **sind** das Produkt für Downstream-Agenten. |
| "Die Absicht ist klar" | Absicht ≠ Implementierung. Auditieren Sie die Implementierung. |
| "Ich beschreibe das Design, nicht den aktuellen Zustand" | Dann sagen Sie "geplant", verwenden Sie nicht das Präsens. |
| "Der Geist der Änderung ist richtig" | Der Buchstabe IST der Geist. Auditieren Sie das tatsächliche Diff. |
| "Nur dieses eine Mal" | Es gibt kein Nur-dieses-eine-Mal. Jede Behauptung wird auditiert. |

## Workflow

### 1. Scope identifizieren

```bash
bash scripts/scan-changed-files.sh
```

Oder git diff direkt. Listen Sie Dateien auf, die in der Session erstellt/modifiziert wurden.

Wenn `$ARGUMENTS` einen spezifischen Scope enthält (z.B. `/congruence headlines`, `/congruence pricing`), filtern Sie nur Dateien/Bereiche, die zum Scope passen.

### 2. Behauptungen extrahieren

Lesen Sie jeden Session-Output und jede modifizierte Datei. Wandeln Sie implizite und explizite Aussagen in objektive Behauptungen um. Guide: [references/claim-extraction-guide.md](references/claim-extraction-guide.md).

### 3. Nach Beweisen suchen

Suchen Sie für jede Behauptung die Wahrheitsquelle in der Hierarchie (ausführbar > Routen/Handler > Schemas > Tests > Config > UI > Mocks > Docs > README > Kommentare > Agent-Text).

### 4. Klassifizieren

| Status | Bedeutung |
|--------|-----------|
| `kongruent` | Beweis bestätigt |
| `inkongruent` | Beweis widerspricht |
| `teilweise kongruent` | Teil korrekt, wichtige Auslassungen |
| `nicht überprüfbar` | Unzureichende Beweise |

Schweregrad: [references/severity-rubric.md](references/severity-rubric.md).

### 5. Bericht

Pflicht-Template: [references/report-format.md](references/report-format.md).

### 6. Pre-Deploy-Entscheidung

- Jedes `kritisch` → **nicht freigeben**
- Ungelöste `hoch` → **nicht freigeben**
- Viele `nicht überprüfbar` in essentiellen Bereichen → **manuelle Review erfordern**
- Nur `mittel`/`niedrig` → **mit Vorbehalt freigeben**
- Alles `kongruent` → **freigeben**

## Dispatch eines Auditor-Subagenten (optional)

Wenn der Scope groß ist (vollständiger Seiten-Audit, lange Release Notes, mehrere Bereiche), kann der aktuelle Agent voreingenommen sein, weil er die Behauptungen generiert hat. **Einen frischen Subagenten zu dispatchen vermeidet Selbstbestätigung.**

**Wann den User fragen:**
- Mehr als 5 Behauptungen zu auditieren
- Änderungen berühren 3+ verschiedene Domains (Docs + UI + Integrations, zum Beispiel)
- Release Notes oder PR-Beschreibung länger als 200 Zeilen
- User hat "auditiere alles" gesagt ohne Scope-Angabe

**Wie fragen:**

> "Ich habe N Behauptungen in M Bereichen erkannt. Soll ich einen spezialisierten Subagenten parallel dispatchen? (ja/nein/nur dieser Teil)"

**Wenn User zustimmt** (oder bei Aufruf mit `/congruence --dispatch-agent`):
- Verwenden Sie das Task-Tool mit dem Template in [auditor-prompt.md](auditor-prompt.md)
- Übergeben Sie Scope, extrahierte Behauptungsliste und Base-/Head-SHAs
- Warten Sie auf den strukturierten Bericht und konsolidieren Sie ihn in die finale Entscheidung

**Bei Inline-Ausführung**: fahren Sie mit dem obigen Workflow fort.

> **Versteckte Kosten**: Jeder Subagent lädt CLAUDE.md + alle Skill-Beschreibungen neu. Dispatch ist teuer für kleine Audits. Standard ist Inline.

## Wann NICHT verwenden

- Technisches Code Review (Bugs, Performance, Security) → verwenden Sie `requesting-code-review`
- Verifizieren, dass Code kompiliert / Tests bestehen → verwenden Sie `verification-before-completion`
- Linting, Formatierung
- Isolierte Unit-Test-Review

## Verwandte Skills

- **superpowers:verification-before-completion** — verifiziert, dass der **Code funktioniert** (Tests, Build). `congruence` verifiziert, dass die **Behauptungen über den Code** mit dem Code übereinstimmen. Verwenden Sie beide vor jedem Release.
- **superpowers:systematic-debugging** — wenn ein Congruence-Audit "Code macht X, aber Docs sagen Y" aufdeckt, debuggen Sie systematisch, anstatt nur die Doc zu patchen.
- **superpowers:requesting-code-review** — technische Qualität. Komplementär, kein Ersatz.

## Warum das wichtig ist

Agenten halluzinieren. Technisches Code Review fängt das nicht ab, weil der Code korrekt ist — was falsch ist, ist die **Information über den Code**.

Reale Beispiele:
- FAQ beschreibt 3-Schritt-Flow, der tatsächlich 5 Schritte hat
- README dokumentiert Preis 49 €, aber Stripe berechnet 79 €
- Landing Page kündigt WhatsApp-Integration an, die nicht existiert
- Setup fordert Node 18, Projekt verlangt aber Node 20
- "123 aktive Leads" zählt gelöschte Leads mit
- CTA "Sichern Sie sich Ihren kostenlosen Platz" führt zu einem 497-€-Checkout
- Headline auf DE, Formular auf EN (Sprachen vermischt)
- Datum "17. Mai 2026" im Hero, "17/05/2025" im Footer

All das **besteht jedes technische Code Review**, weil der Code kompiliert und läuft. `congruence` ist die Barriere gegen diese Fehlerklasse.

## Unverletzliche Regeln

1. Text, den der Agent gerade generiert hat, ist **niemals** eine Wahrheitsquelle
2. Plausibilität ist **kein** Beweis — konkreter Beweis erforderlich
3. Kein Beweis → `nicht überprüfbar`, **niemals** `kongruent`
4. `kritisch`/`hoch`-Issues **blockieren** Deploy/Merge
5. Bericht wird **immer** generiert, auch wenn alles `kongruent` ist
6. **Den Buchstaben zu verletzen heißt, den Geist zu verletzen** — keine Ausnahmen, kein "nur dieses eine Mal"

---

**Sprachen:** [🇺🇸 English](SKILL.md) · [🇧🇷 Português](SKILL.pt-BR.md) · [🇪🇸 Español](SKILL.es.md) · [🇫🇷 Français](SKILL.fr.md) · 🇩🇪 Deutsch · [🇨🇳 中文](SKILL.zh.md)

<!-- TRANSLATION NOTE: AI-generated. Native speaker review recommended for technical terms like "Gate Function", "Iron Law", and severity labels. -->
