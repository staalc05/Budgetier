import { Injectable } from '@nestjs/common';

/**
 * A stub implementation of an aggregator service for Tink. In a production
 * application this service would handle OAuth flows via Tink Link, store
 * refresh tokens, fetch accounts and transactions and handle webhook
 * notifications. Here we provide placeholder methods to illustrate how such
 * a service might look without actually performing network calls.
 */
@Injectable()
export class TinkService {
  /**
   * Starts the authentication flow with Tink and returns a URL that the
   * client should redirect the user to. Once the user completes the flow
   * Tink will call back your application with an authorization code.
   */
  initiateAuth(userId: number): string {
    // In reality this would create a consent with Tink and generate a
    // user‑specific URL. For demonstration purposes we return a dummy URL.
    return `https://link.tink.com/1.0/authorize/?user_id=${userId}&mock=true`;
  }

  /**
   * Exchanges the provided authorization code for a long‑lived refresh token.
   * You would store the resulting token in the bank_connections table. Here
   * we simply return a mocked token.
   */
  async exchangeAuthorizationCode(code: string): Promise<{ accessToken: string; expiresAt: Date }> {
    // Simulate token exchange delay
    await new Promise((resolve) => setTimeout(resolve, 100));
    return {
      accessToken: `mock_access_token_${code}`,
      expiresAt: new Date(Date.now() + 1000 * 60 * 60),
    };
  }

  /**
   * Fetches the list of accounts associated with the specified connection.
   * Returns a simplified representation of accounts. In a real
   * implementation you would call the Tink API using the stored token.
   */
  async fetchAccounts(connectionId: number): Promise<any[]> {
    // Placeholder list of accounts. Real data would include IBANs,
    // currency, balances and other metadata.
    return [
      {
        id: `acc_mock_${connectionId}_1`,
        name: 'Current Account',
        iban: 'AT00 0000 0000 0000',
        currency: 'EUR',
        balance: 1234.56,
      },
      {
        id: `acc_mock_${connectionId}_2`,
        name: 'Savings Account',
        iban: 'AT00 0000 0000 0001',
        currency: 'EUR',
        balance: 9876.54,
      },
    ];
  }

  /**
   * Fetches transactions for a given account over a date range. Again, this
   * function returns mocked values to illustrate the expected shape of the
   * response.
   */
  async fetchTransactions(accountId: string, from: Date, to: Date): Promise<any[]> {
    return [
      {
        id: `txn_${accountId}_1`,
        date: from.toISOString().slice(0, 10),
        amount: -42.5,
        currency: 'EUR',
        description: 'Grocery Store',
        counterparty: 'Billa',
      },
      {
        id: `txn_${accountId}_2`,
        date: to.toISOString().slice(0, 10),
        amount: -15.0,
        currency: 'EUR',
        description: 'Coffee Shop',
        counterparty: 'Starbucks',
      },
    ];
  }
}