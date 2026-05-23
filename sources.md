# Sources

The research behind these defaults. Grouped by topic. Every link is to a primary or well-regarded secondary source. If you want to build your own companion notebook, this is the reading list.

## How AI coding agents go wrong (incident overviews)

- Docker — [AI Coding Agent Horror Stories: Security Risks Explained](https://www.docker.com/blog/ai-coding-agent-horror-stories-security-risks/)
- Fiddler AI — [Artificial Intelligence Security Issues: Coding Agent Risks](https://www.fiddler.ai/blog/artificial-intelligence-security-issues)
- Recorded Future — [Emerging Enterprise Security Risks of AI](https://www.recordedfuture.com/research/emerging-enterprise-security-risks-of-ai)
- TechRadar — [AI code security risk: the need for a smarter layer between detection and remediation](https://www.techradar.com/pro/ai-code-security-risk-the-need-for-a-smarter-layer-between-detection-and-remediation)
- Tessl (podcast) — [The Hidden Security Risks of AI Coding Agents](https://tessl.io/podcast/106)

## Prompt injection: the core unsolved risk

- Simon Willison — [The Lethal Trifecta for AI agents (talk)](https://simonwillison.net/2025/Aug/9/bay-area-ai/)
- Simon Willison — [Design Patterns for Securing LLM Agents against Prompt Injections](https://simonwillison.net/2025/Jun/13/prompt-injection-design-patterns/)
- Microsoft MSRC — [How Microsoft defends against indirect prompt injection attacks](https://www.microsoft.com/en-us/msrc/blog/2025/07/how-microsoft-defends-against-indirect-prompt-injection-attacks)
- Unit 42, Palo Alto Networks — [Fooling AI Agents: Web-Based Indirect Prompt Injection Observed in the Wild](https://unit42.paloaltonetworks.com/ai-agent-prompt-injection/)
- arXiv — [Prompt Injection Attacks on Agentic Coding Assistants: A Systematic Analysis](https://arxiv.org/abs/2601.17548)
- Narek Maloyan — [Prompt Injection Attacks on Agentic Coding Assistants](https://maloyan.xyz/blog/agentic-coding-assistants-injection)

## Instructions hidden in files

- Pillar Security — [New Vulnerability in GitHub Copilot and Cursor: the Rules File Backdoor](https://www.pillar.security/blog/new-vulnerability-in-github-copilot-and-cursor-how-hackers-can-weaponize-code-agents)
- NVIDIA — [Mitigating Indirect AGENTS.md Injection Attacks in Agentic Environments](https://developer.nvidia.com/blog/mitigating-indirect-agents-md-injection-attacks-in-agentic-environments/)

## MCP (the protocol that connects agents to tools)

- NSA — [Model Context Protocol (MCP): Security Design Considerations for AI-Driven Automation (PDF)](https://www.nsa.gov/Portals/75/documents/Cybersecurity/CSI_MCP_SECURITY.pdf)
- SOC Prime — [Model Context Protocol: Security Risks & Mitigations](https://socprime.com/blog/mcp-security-risks-and-mitigations/)
- OX Security — [The Architectural Flaw at the Core of MCP](https://www.ox.security/blog/the-mother-of-all-ai-supply-chains-critical-systemic-vulnerability-at-the-core-of-the-mcp/)

## Supply chain: the packages an agent installs

- Snyk — [Package Hallucination: When AI Creates Phantom Packages](https://snyk.io/articles/package-hallucinations/)
- Aikido — [Slopsquatting: the AI Package Hallucination Attack](https://www.aikido.dev/blog/slopsquatting-ai-package-hallucination-attacks)

## The OWASP agentic risk framework

- F5 Networks — [OWASP Top 10 for Agentic AI Applications](https://www.f5.com/glossary/owasp-top-10-for-agentic-ai-applications)
- Promptfoo — [OWASP Top 10 for Agentic Applications](https://www.promptfoo.dev/docs/red-team/owasp-agentic-ai/)
- Lakera — [The Progressive Breach Model Behind the OWASP Top 10 for Agentic Applications](https://www.lakera.ai/blog/the-progressive-breach-model-behind-the-owasp-top-10-for-agentic-applications)

## Claude Code's own defenses

- Anthropic — [Making Claude Code more secure and autonomous with sandboxing](https://www.anthropic.com/engineering/claude-code-sandboxing)
- Claude Code Docs — [Configure the sandboxed Bash tool](https://code.claude.com/docs/en/sandboxing)
