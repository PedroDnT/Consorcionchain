import { ethers } from 'ethers';
import EnhancedConsorcioManagerABI from '../contracts/EnhancedConsorcioManager.json';

const contractAddress = '0x84F9B232D70d14f6523c9c5Bc5bd2304Ff41DA71';

export const getContract = async () => {
  if (typeof window.ethereum !== 'undefined') {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, EnhancedConsorcioManagerABI.abi, signer);
    return contract;
  }
  return null;
};

export const createConsorcio = async (name, totalValue, monthlyPayment, numberOfParticipants) => {
  const contract = await getContract();
  if (contract) {
    try {
      const tx = await contract.createConsorcio(name, totalValue, monthlyPayment, numberOfParticipants);
      await tx.wait();
      return true;
    } catch (error) {
      console.error('Error creating consorcio:', error);
      return false;
    }
  }
  return false;
};
