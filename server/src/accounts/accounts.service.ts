import { Injectable } from '@nestjs/common';
import { TinkService } from '../aggregator/tink.service';

/**
 * Service providing methods to retrieve accounts and transactions through the
 * configured aggregator. All results are currently mocked via TinkService.
 */
@Injectable()
export class AccountsService {
  constructor(private readonly tinkService: TinkService) {}

  /**
   * Retrieves all accounts associated with the provided bank connection. In a
   * full implementation this would use the stored access token for the
   * connection to query the aggregator.
   */
  async getAccounts(connectionId: number) {
    return this.tinkService.fetchAccounts(connectionId);
  }

  /**
   * Retrieves transactions for the given account between the specified
   * dates. Delegates to the TinkService stub for demonstration.
   */
  async getTransactions(accountId: string, from: Date, to: Date) {
    return this.tinkService.fetchTransactions(accountId, from, to);
  }
}