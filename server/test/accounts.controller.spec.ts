import { Test, TestingModule } from '@nestjs/testing';
import { AccountsController } from '../src/accounts/accounts.controller';
import { AccountsService } from '../src/accounts/accounts.service';

describe('AccountsController', () => {
  let controller: AccountsController;
  let service: AccountsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AccountsController],
      providers: [
        {
          provide: AccountsService,
          useValue: {
            getAccounts: jest.fn().mockResolvedValue(['acc']),
            getTransactions: jest.fn().mockResolvedValue(['tx']),
          },
        },
      ],
    }).compile();

    controller = module.get<AccountsController>(AccountsController);
    service = module.get<AccountsService>(AccountsService);
  });

  it('returns accounts from the service', async () => {
    await expect(controller.getAccounts(1)).resolves.toEqual(['acc']);
    expect(service.getAccounts).toHaveBeenCalledWith(1);
  });

  it('returns transactions from the service', async () => {
    await expect(controller.getTransactions('a')).resolves.toEqual(['tx']);
    expect(service.getTransactions).toHaveBeenCalledWith(
      'a',
      expect.any(Date),
      expect.any(Date),
    );
  });
});
