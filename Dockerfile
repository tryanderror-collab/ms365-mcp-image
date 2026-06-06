# Vorgebautes Image für den M365-MCP-Server.
# Zweck: Das npm-Paket wird EINMAL ins Image gebacken -> der Kaltstart ist
# danach nur noch "node startet" (10-40 s) statt "npx laedt 1-3 Min nach".
FROM node:22-slim

# Gepinnte Server-Version. Verifiziert via npm-Registry am 2026-06-06.
# Aktuelle stabile Version: 0.108.0
ARG MS365_MCP_VERSION=0.108.0

# Server global installieren. Die optionalen Azure-Key-Vault-Pakete
# (@azure/identity, @azure/keyvault-secrets) kommen mit -> Zugangsdaten
# bleiben zur Laufzeit aus dem Key Vault.
# keytar (OS-Schluesselbund, im Container ungenutzt) ueberspringt ggf. seinen
# nativen Build -> harmlos, der Install laeuft trotzdem durch.
RUN npm install -g @softeria/ms-365-mcp-server@${MS365_MCP_VERSION} \
    && npm cache clean --force

# Wichtig: Die Container-App behaelt ihre vorhandenen Args + Env
# (z. B. --http, Port, Key-Vault-secretrefs). Das Image fuehrt nur die
# bereits installierte Binary aus -> kein npx mehr.
ENTRYPOINT ["ms-365-mcp-server"]
