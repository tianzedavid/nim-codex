import pkg/ethers
import pkg/serde/json

proc blockTime*(provider: Provider, tag: BlockTag): Future[UInt256] {.async.} =
  return (!await provider.getBlock(tag)).timestamp

proc currentTime*(provider: Provider): Future[UInt256] {.async.} =
  return await provider.blockTime(BlockTag.pending)

proc advanceTime*(provider: JsonRpcProvider, seconds: UInt256) {.async.} =
  discard await provider.send("evm_increaseTime", @[%("0x" & seconds.toHex)])
  discard await provider.send("evm_mine")

proc advanceTimeTo*(provider: JsonRpcProvider, timestamp: UInt256) {.async.} =
  if (await provider.currentTime()) != timestamp:
    discard
      await provider.send("evm_setNextBlockTimestamp", @[%("0x" & timestamp.toHex)])
    discard await provider.send("evm_mine")
