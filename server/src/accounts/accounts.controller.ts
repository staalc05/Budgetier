import { Controller, Get, Param, Query } from '@nestjs/common';
import { AccountsService } from './accounts.service';

/**
 * Controller exposing read‑only endpoints for listing bank accounts and
 * transactions. All requests delegate to the AccountsService which in turn
 * calls the aggregator stub.
 */
@Controller('accounts')
export class AccountsController {
  constructor(private readonly accountsService: AccountsService) {}

  /**
   * Lists the accounts linked to a given bank connection. Clients must
   * supply the connectionId which would normally correspond to a row in
   * bank_connections. For the MVP this returns mocked data.
   */
  @Get(':connectionId')
  async getAccounts(@Param('connectionId') connectionId: number) {
    return this.accountsService.getAccounts(connectionId);
  }

  /**
   * Lists transactions for a specified account within an optional date range.
   * Dates should be provided as ISO strings. If omitted a default range
   * covering the last 30 days is used.
   */
  @Get(':accountId/transactions')
  async getTransactions(
    @Param('accountId') accountId: string,
    @Query('from') from?: string,
    @Query('to') to?: string,
  ) {
    const fromDate = from ? new Date(from) : new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const toDate = to ? new Date(to) : new Date();
    return this.accountsService.getTransactions(accountId, fromDate, toDate);
  }
}