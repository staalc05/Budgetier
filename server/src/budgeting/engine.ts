/**
 * Core budgeting formulas used by the Budgetier backend. While simplified for the
 * initial MVP, these functions encapsulate the same logic described in the
 * product specification: computing daily allowances, handling underspend and
 * overspend, and keeping values above zero. Additional functions can be added
 * here to support goal adaptation and fixed cost detection.
 */

export interface AllowanceParams {
  periodStart: Date;
  periodEnd: Date;
  income: number;
  fixedCosts: number;
  goalContribution: number;
  spentToDate: number;
  savingsSlider: number;
  spentToday: number;
}

export interface AllowanceResult {
  /** Calculated daily allowance for today. This value is never negative. */
  allowanceToday: number;
  /** Number of days left in the current period including today. */
  daysLeft: number;
  /** Baseline allowance if nothing had been spent to date. */
  baseAllowance: number;
}

/**
 * Calculates the daily allowance for the current day based on the provided
 * parameters. The algorithm divides the remaining budget by the number of
 * days left and ensures that the result is non‑negative. It does not yet
 * implement the full under/overspend redistribution described in the
 * specification but serves as a foundation for future enhancements.
 */
export function calculateDailyAllowance(params: AllowanceParams): AllowanceResult {
  const {
    periodStart,
    periodEnd,
    income,
    fixedCosts,
    goalContribution,
    spentToDate,
    savingsSlider,
    spentToday,
  } = params;
  // Compute total days in the cycle and remaining days. We add one to include
  // both the start and end date when calculating durations in days.
  const msPerDay = 24 * 60 * 60 * 1000;
  const totalDays = Math.floor((periodEnd.getTime() - periodStart.getTime()) / msPerDay) + 1;
  const today = new Date();
  const daysLeft = Math.max(1, Math.floor((periodEnd.getTime() - today.getTime()) / msPerDay) + 1);

  // Determine the net budget pool available for variable spending.
  const net = income - fixedCosts - goalContribution - spentToDate;
  // Compute a baseline daily allowance based on the entire cycle.
  const base = net / totalDays;
  // Compute the allowance for today based on remaining days and update it if
  // under or overspend occurred. For now we ignore underspend/overspend and
  // simply divide the remaining pool by days left.
  const remainingPool = net - spentToday;
  const allowanceRaw = remainingPool / daysLeft;
  const allowanceToday = allowanceRaw < 0 ? 0 : allowanceRaw;
  return {
    allowanceToday,
    daysLeft,
    baseAllowance: base,
  };
}