---
# Source: root-1kv-backend/templates/kusama-otv-backend.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kusama-otv-backend
  namespace: argocd
# finalizers:
# - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: kusama
  project: 1kv-backend
  # syncPolicy:
  #   automated:
  #     prune: true
  #     selfHeal: true 
  source:
    repoURL: https://w3f.github.io/helm-charts/
    chart: otv-backend
    targetRevision: v2.8.31
    plugin:
      env:
        - name: HELM_VALUES
          value: |
            image:
              tag: "v2.8.31"
            environment: production
            dataPath: "/data"
            backendPort: 3300
            domain: "kusama.w3f.community"

            resources:
              limits:
                cpu: 3500m
                memory: 9Gi
              requests:
                cpu: 700m
                memory: 3Gi

            secret: |
              <path:vaults/k8s-community-secrets/items/otv-kusama#backend-secret>

            config: |
              {
                "global": {
                  "dryRun": false,
                  "networkPrefix": 2,
                  "test": false,
                  "retroactive": false,
                  "historicalNominations": false,
                  "apiEndpoints":  ["wss://kusama-rpc.polkadot.io","wss://kusama.api.onfinality.io/public-ws","wss://kusama-rpc.dwellir.com","wss://kusama.public.curie.radiumblock.xyz/ws"]
                },
                "constraints": {
                  "skipConnectionTime": false,
                  "skipIdentity": false,
                  "skipStakedDestination": true,
                  "skipClientUpgrade": false,
                  "forceClientVersion": "v0.9.39",
                  "skipUnclaimed": true,
                  "minSelfStake": 10000000000000,
                  "commission": 150000000,
                  "unclaimedEraThreshold": 4
                },
                "cron": {
                  "monitor": "0 */15 * * * *"
                },
                "db": {
                  "mongo": {
                      "uri": "mongodb://<path:vaults/k8s-community-secrets/items/otv-kusama#mongo-username>:<path:vaults/k8s-community-secrets/items/otv-kusama#mongo-password>@kusama-mongodb-headless.kusama.svc.cluster.local/otv?tls=false&replicaSet=rs0"
                  }
                },
                "matrix": {
                  "enabled": true,
                  "baseUrl": "https://matrix.org",
                  "room": "!mdugGIKqSTweIOpTlA:web3.foundation",
                  "userId": "@1kv-stats:matrix.org"
                },
                "proxy": {
                    "timeDelayBlocks": "10850",
                    "blacklistedAnnouncements": []
                },
                "score":                
                
                    {
                      "score": {
                        "inclusion": "200",
                        "spanInclusion": "200",
                        "discovered": "5",
                        "nominated": "30",
                        "rank": "5",
                        "bonded": "50",
                        "faults": "5",
                        "offline": "2",
                        "location": "40",
                        "region": "10",
                        "country": "10",
                        "provider": "100",
                        "council": "50",
                        "democracy": "100",
                        "nominations": "100",
                        "delegations": "60",
                        "openGov": "100",
                        "openGovDelegation": "100"
                      }
                    },
                "scorekeeper": {
                  "candidates": 
                    [
                      {
                        "name": "Blockshard",
                        "stash": "Cp4U5UYg2FaVUpyEtQgfBm9aqge6EEPkJxEFVZFYy7L1AZF",
                        "riotHandle": "@marc1104:matrix.org",
                      },
                      {
                        "name": "🎠 Forbole GP01 🇭🇰",
                        "stash": "D9rwRxuG8xm8TZf5tgkbPxhhTJK5frCJU9wvp59VRjcMkUf",
                        "riotHandle": "@kwunyeung:matrix.org",
                      },
                    ],
                  "forceRound": false,
                  "nominating": true
                },
                "server": {
                  "port": 3300,
                  "enable": true
                },
                "telemetry": {
                  "enable": true,
                  "chains": [
                      "0xb0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe"
                  ],
                  "blacklistedProviders": [
                    "Hetzner Online GmbH",
                    "Contabo Inc.",
                    "Contabo GmbH"
                  ],
                  "host": "wss://telemetry-backend.w3f.community/feed"
                },
                "subscan": {
                    "baseV1Url": "https://kusama.api.subscan.io/api/scan",
                    "baseV2Url": "https://kusama.api.subscan.io/api/v2/scan"
                }
              }
