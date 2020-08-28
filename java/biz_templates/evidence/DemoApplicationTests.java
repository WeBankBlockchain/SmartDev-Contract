package com.example.demo;

import com.example.demo.contracts.Evidence;
import com.example.demo.contracts.EvidenceRepository;
import com.example.demo.contracts.RequestRepository;
import org.fisco.bcos.web3j.crypto.ECKeyPair;
import org.fisco.bcos.web3j.crypto.gm.GenCredential;
import org.fisco.bcos.web3j.protocol.Web3j;
import org.fisco.bcos.web3j.protocol.core.methods.response.TransactionReceipt;
import org.fisco.bcos.web3j.tx.gas.ContractGasProvider;
import org.fisco.bcos.web3j.utils.Numeric;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

@SpringBootTest
class DemoApplicationTests {

	@Autowired
	private Web3j web3j;

	@Autowired
	private ContractGasProvider contractGasProvider;

	@Test
	void test() throws Exception{
		//准备用户
		ECKeyPair aUser = GenCredential.createKeyPair();
		ECKeyPair bUser = GenCredential.createKeyPair();
		ECKeyPair cUser = GenCredential.createKeyPair();

		//部署基于2-3投票的合约
		BigInteger threshold = BigInteger.valueOf(2);
		List<String> voters = Arrays.asList(GenCredential.create(bUser).getAddress(), GenCredential.create(cUser).getAddress());
		EvidenceRepository storageContract = EvidenceRepository.deploy(web3j, GenCredential.create(aUser), contractGasProvider).send();
		RequestRepository voteRepository = RequestRepository.deploy(web3j, GenCredential.create(aUser), contractGasProvider, threshold, voters).send();
		Evidence evidenceA = Evidence.deploy(web3j, GenCredential.create(aUser), contractGasProvider, voteRepository.getContractAddress(), storageContract.getContractAddress()).send();
		storageContract.allow(evidenceA.getContractAddress()).send();
		voteRepository.allow(evidenceA.getContractAddress()).send();
		//A创建存证请求
		byte[] hash = Numeric.toBytesPadded(BigInteger.TEN, 32);
		byte[] ext = Numeric.toBytesPadded(BigInteger.TEN, 1);
		evidenceA.createSaveRequest(hash, ext).send();
		//B和C进行审核
		Evidence evidenceB = Evidence.load(evidenceA.getContractAddress(), web3j, GenCredential.create(bUser), contractGasProvider);
		Evidence evidenceC = Evidence.load(evidenceA.getContractAddress(), web3j, GenCredential.create(cUser), contractGasProvider);
		Object obj = evidenceB.getRequestData(hash).send();
		TransactionReceipt receipt = evidenceB.voteSaveRequest(hash).send();

		evidenceC.voteSaveRequest(hash).send();
		//A取证
		Object evidence = evidenceA.getEvidence(hash).send();
		int i =0;

	}

}
