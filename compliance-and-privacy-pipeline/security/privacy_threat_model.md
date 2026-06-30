# Privacy Threat Model for Sample Web Application

## LINDDUN Privacy Threats Analysis
- **Linking**: User activities can be linked across sessions. Mitigation: pseudonyms.
- **Identifying**: Users identified via email. Mitigation: hash emails.
- **Non-repudiation**: Actions logged. Mitigation: selective logging.
- **Detecting**: User presence detectable. Mitigation: privacy-preserving analytics.
- **Data Disclosure**: SQLite DB exposes data. Mitigation: encryption.
- **Unawareness**: Users unaware of collection. Mitigation: clear consent.
- **Non-compliance**: Violates GDPR. Mitigation: implement compliance controls.
