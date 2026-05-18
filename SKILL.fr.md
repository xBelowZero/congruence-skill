---
name: congruence
description: À utiliser chaque fois que vous êtes sur le point de déclarer un travail terminé, de faire un commit, d'ouvrir une PR, de mettre à jour README/CHANGELOG/docs, ou de livrer une modification affectant du texte visible par l'utilisateur — vérifie si ce que l'agent a dit, écrit ou documenté correspond réellement à ce que fait le code. À utiliser proactivement avant TOUTE affirmation de complétion. DÉCLENCHER lorsque l'agent utilise des expressions comme "supporte maintenant", "implémenté", "fonctionne", "prêt", "corrigé", "ajouté" ; lorsque les fichiers modifiés incluent README, CHANGELOG, docs/, help-center, FAQ, landing page, copy d'UI, ou prompts IA ; avant release/deploy. IGNORER lorsque les modifications sont uniquement de formatage, bumps de version de dépendances, refactors internes sans texte user-facing touché, ou modifications uniquement dans des fichiers de test.
argument-hint: [scope?] [--dispatch-agent?]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(scripts/scan-changed-files.sh:*), Task
---

# Congruence

Vérifie si ce que l'agent a dit, écrit ou documenté correspond à ce que le code fait réellement. **Ceci n'est pas une revue de code technique.** C'est un audit de **vérité sémantique**.

**Principe central :** Aucune affirmation sur le projet n'est vraie sans preuve dans le projet lui-même.

**Violer la lettre de cette règle, c'est violer son esprit.** Le texte que l'agent vient de générer n'est jamais une source de vérité — pas même avec des qualificatifs comme "probablement", "devrait être", "j'ai supposé que".

## La Loi de Fer

```
AUCUNE AFFIRMATION VISIBLE PAR L'UTILISATEUR SANS PREUVE DE TERRAIN
```

Si vous avez écrit "l'application fait maintenant X" et que vous ne pouvez pas pointer vers le fichier/test/route qui prouve X, vous **ne pouvez pas** publier cette affirmation. Rétrogradez vers "planifié", "partiel", ou supprimez-la.

## Gate Function — avant toute affirmation ou édition de doc

Exécutez dans l'ordre. Chaque étape bloque la suivante si incomplète.

1. **EXTRAIRE** — listez chaque affirmation concrète dans l'output ("supporte X", "j'ai corrigé Y", "affiche maintenant Z"). Voir [references/claim-extraction-guide.md](references/claim-extraction-guide.md) si vous avez besoin de techniques.
2. **MAPPER** — pour chaque affirmation, pointez vers fichier:ligne/test/route qui la prouve. Aucune cible ? Marquez comme `non vérifiable`.
3. **AUDITER** — pour chaque affirmation non prouvée : **supprimez** ou **rétrogradez** vers "planifié/partiel/en cours".
4. **CROSS-CHECK** — assurez-vous que la terminologie dans les docs correspond au code (noms de fonctions, env vars, routes, labels).
5. **ÉMETTRE** — seulement maintenant générez le message/commit/PR/release notes.

## Tableau de preuves par type d'affirmation

| Affirmation | Requiert | Insuffisant |
|-------------|----------|-------------|
| "Supporte maintenant X" | Test qui passe + nom de fonction/route grepable | "J'ai ajouté un TODO", "le scaffolding existe" |
| "J'ai corrigé le bug Y" | Test rouge → test vert (red-green) | "Le code a changé, ça a l'air bon" |
| "Le README dit X" | grep README + grep code, les deux contiennent X | édition du README seule |
| "Renommé Y en Z" | grep tout le repo : 0 occurrences de Y | renommé dans 1 fichier |
| "Supprimé la fonctionnalité W" | grep code + README + tests → 0 occurrences | supprimé seulement du code |
| "Intègre avec Stripe/X" | Code + env var + handler/webhook configuré | mock ou `// TODO: intégrer Stripe` |
| "Prix/date/nombre X" | grep de la valeur littérale dans le source (config, db seed, ou en dur) | Nombre apparaît seulement dans la copy générée |
| "A X options dans le select" | Le composant liste exactement X items, pas mock | "devrait avoir environ X options" |

Guide approfondi : [references/source-of-truth-priority.md](references/source-of-truth-priority.md)

## Red Flags — STOP

Si vous vous surprenez à penser ou écrire :

- "devrait fonctionner", "est probablement", "j'ai supposé que", "c'est implicite"
- Écrire le README **avant** le code (ou après, sans relire le code)
- Coller une description de PR générée par LLM sans grep
- "Je vais mentionner X dans les docs, l'utilisateur trouvera l'orthographe exacte"
- Renommer une fonction sans grep dans tout le repo
- Le status report inclut une fonctionnalité implémentée "plus tôt dans la session" sans re-vérifier
- `package.json`/`README` décrivent quelque chose de différent de ce que fait réellement l'entry point
- Copy marketing/landing promet un bénéfice sans code derrière

→ STOP. Retournez à l'étape 1 de la Gate Function.

## Tableau Excuse | Réalité

| Excuse | Réalité |
|--------|---------|
| "L'utilisateur corrigera le README plus tard" | Une affirmation publiée = une affirmation faite. Vérifier ou supprimer. |
| "Assez proche" | Proche ≠ vrai. Le code est binaire, l'affirmation aussi. |
| "Ce ne sont que des docs" | Les docs **sont** le produit pour les agents downstream. |
| "L'intention est claire" | Intention ≠ implémentation. Auditez l'implémentation. |
| "Je décris le design, pas l'état actuel" | Alors dites "planifié", n'utilisez pas le présent. |
| "L'esprit du changement est correct" | La lettre EST l'esprit. Auditez le diff réel. |
| "Juste cette fois" | Il n'y a pas de juste-cette-fois. Chaque affirmation est auditée. |

## Workflow

### 1. Identifier le scope

```bash
bash scripts/scan-changed-files.sh
```

Ou git diff directement. Listez les fichiers créés/modifiés dans la session.

Si `$ARGUMENTS` contient un scope spécifique (ex : `/congruence headlines`, `/congruence pricing`), filtrez seulement les fichiers/zones correspondant au scope.

### 2. Extraire les affirmations

Lisez chaque output de session et chaque fichier modifié. Transformez les déclarations implicites et explicites en affirmations objectives. Guide : [references/claim-extraction-guide.md](references/claim-extraction-guide.md).

### 3. Chercher des preuves

Pour chaque affirmation, cherchez la source de vérité dans la hiérarchie (exécutable > routes/handlers > schemas > tests > config > UI > mocks > docs > README > commentaires > texte de l'agent).

### 4. Classifier

| Statut | Signification |
|--------|---------------|
| `congruent` | La preuve confirme |
| `incongruent` | La preuve contredit |
| `partiellement congruent` | Partie correcte, omissions importantes |
| `non vérifiable` | Preuve insuffisante |

Sévérité : [references/severity-rubric.md](references/severity-rubric.md).

### 5. Rapport

Template obligatoire : [references/report-format.md](references/report-format.md).

### 6. Décision pré-deploy

- Tout `critique` → **ne pas approuver**
- `élevé` non résolu → **ne pas approuver**
- Beaucoup de `non vérifiable` dans des zones essentielles → **exiger revue manuelle**
- Seulement `moyen`/`bas` → **approuver avec réserves**
- Tout `congruent` → **approuver**

## Dispatch d'un sous-agent auditeur (optionnel)

Quand le scope est grand (audit de page complète, release notes longues, plusieurs zones), l'agent actuel peut être biaisé par avoir généré les affirmations. **Dispatcher un sous-agent neuf évite l'auto-confirmation.**

**Quand demander à l'utilisateur :**
- Plus de 5 affirmations à auditer
- Modifications touchent 3+ domaines distincts (docs + UI + intégrations, par exemple)
- Release notes ou description de PR de plus de 200 lignes
- L'utilisateur a dit "audite tout" sans préciser le scope

**Comment demander :**

> "J'ai détecté N affirmations dans M zones. Voulez-vous que je dispatch un sous-agent spécialisé pour auditer en parallèle ? (oui/non/juste cette partie)"

**Si l'utilisateur accepte** (ou si invoqué avec `/congruence --dispatch-agent`) :
- Utilisez le Task tool avec le template dans [auditor-prompt.md](auditor-prompt.md)
- Passez scope, liste d'affirmations extraites, et SHAs base/head
- Attendez le rapport structuré et consolidez dans la décision finale

**Si exécution inline** : continuez avec le workflow ci-dessus.

> **Coût caché** : chaque sous-agent recharge CLAUDE.md + toutes les descriptions de skills. Le dispatch est cher pour les petits audits. Le défaut est inline.

## Quand NE PAS utiliser

- Revue de code technique (bugs, performance, sécurité) → utilisez `requesting-code-review`
- Vérifier que le code compile / les tests passent → utilisez `verification-before-completion`
- Linting, formatage
- Revue isolée de tests unitaires

## Skills liées

- **superpowers:verification-before-completion** — vérifie que le **code fonctionne** (tests, build). `congruence` vérifie que les **affirmations sur le code** correspondent au code. Utilisez les deux avant toute release.
- **superpowers:systematic-debugging** — quand un audit de congruence révèle "le code fait X mais les docs disent Y", debug systématiquement au lieu de juste patcher la doc.
- **superpowers:requesting-code-review** — qualité technique. Complémentaire, pas un remplacement.

## Pourquoi c'est important

Les agents hallucinent. La revue de code technique ne détecte pas ça parce que le code est correct — ce qui est faux, c'est l'**information sur le code**.

Exemples réels :
- FAQ décrit un flow en 3 étapes alors que c'est en fait 5
- README documente un prix de 49 € mais Stripe facture 79 €
- Landing page annonce une intégration WhatsApp qui n'existe pas
- Setup demande Node 18 mais le projet exige Node 20
- "123 leads actifs" compte les leads supprimés
- CTA "Réservez votre place gratuite" mène à un checkout à 497 €
- Headline en FR, formulaire en EN (langues mélangées)
- Date "17 mai 2026" dans le hero, "17/05/2025" dans le footer

Tout cela **passe en revue de code technique** parce que le code compile et fonctionne. `congruence` est la barrière contre ce type d'erreur.

## Règles inviolables

1. Le texte que l'agent vient de générer n'est **jamais** une source de vérité
2. La plausibilité **n'est pas** une preuve — preuve concrète requise
3. Pas de preuve → `non vérifiable`, **jamais** `congruent`
4. Les issues `critique`/`élevé` **bloquent** deploy/merge
5. Rapport généré **toujours**, même si tout est `congruent`
6. **Violer la lettre, c'est violer l'esprit** — pas d'exceptions, pas de "juste cette fois"

---

**Langues :** [🇺🇸 English](SKILL.md) · [🇧🇷 Português](SKILL.pt-BR.md) · [🇪🇸 Español](SKILL.es.md) · 🇫🇷 Français · [🇩🇪 Deutsch](SKILL.de.md) · [🇨🇳 中文](SKILL.zh.md)
