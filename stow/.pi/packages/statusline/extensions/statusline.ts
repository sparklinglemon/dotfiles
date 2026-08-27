import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, type TUI, visibleWidth } from "@earendil-works/pi-tui";

function formatCwd(cwd: string): string {
	const home = process.env.HOME;
	if (home && cwd === home) return "~";
	if (home && cwd.startsWith(`${home}/`)) return `~${cwd.slice(home.length)}`;
	return cwd;
}

function formatContext(ctx: ExtensionContext): string {
	const usage = ctx.getContextUsage();
	const contextWindow = usage?.contextWindow ?? ctx.model?.contextWindow;
	if (!contextWindow) return "ctx ?";

	const size = contextWindow >= 1000 ? `${Math.round(contextWindow / 1000)}k` : `${contextWindow}`;
	if (!usage || usage.percent === null) return `ctx ?/${size}`;
	return `ctx ${Math.round(usage.percent)}%/${size}`;
}

function fitLine(left: string, right: string, width: number): string {
	if (width <= 0) return "";
	let leftText = left;
	let rightText = right;
	const minimumGap = 1;

	while (visibleWidth(leftText) + visibleWidth(rightText) + minimumGap > width && visibleWidth(rightText) > 0) {
		rightText = truncateToWidth(rightText, Math.max(0, visibleWidth(rightText) - 1), "");
	}
	while (visibleWidth(leftText) + visibleWidth(rightText) + minimumGap > width && visibleWidth(leftText) > 0) {
		leftText = truncateToWidth(leftText, Math.max(0, visibleWidth(leftText) - 1), "");
	}

	const gap = " ".repeat(Math.max(1, width - visibleWidth(leftText) - visibleWidth(rightText)));
	return truncateToWidth(leftText + gap + rightText, width);
}

export default function (pi: ExtensionAPI) {
	let activeTui: TUI | undefined;
	const refresh = () => activeTui?.requestRender();

	for (const event of ["model_select", "thinking_level_select", "message_end", "session_compact", "session_tree"] as const) {
		pi.on(event, refresh);
	}

	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			activeTui = tui;
			const unsubBranch = footerData.onBranchChange(refresh);

			return {
				dispose() {
					unsubBranch();
					if (activeTui === tui) activeTui = undefined;
				},
				invalidate() {},
				render(width: number): string[] {
					const model = ctx.model?.id ?? "no-model";
					const effort = pi.getThinkingLevel();
					const context = formatContext(ctx);
					const left = theme.fg("accent", `${model} (${effort})`) + theme.fg("dim", ` · ${context}`);
					const right = theme.fg("muted", formatCwd(process.cwd()));
					const branch = footerData.getGitBranch() ?? "no git branch";

					return [
						fitLine(left, right, width),
						truncateToWidth(theme.fg("muted", branch), width),
					];
				},
			};
		});
	});
}
