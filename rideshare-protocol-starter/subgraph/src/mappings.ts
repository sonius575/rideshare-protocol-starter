import { RidePosted, RideAccepted } from "../generated/RideRegistry/RideRegistry"
import { Ride } from "../generated/schema"

export function handleRidePosted(e: RidePosted): void {
  let id = e.params.rideId.toHex()
  let r = new Ride(id)
  r.rider = e.params.rider
  r.token = e.params.token
  r.maxFare = e.params.maxFare
  r.areaHash = e.params.areaHash
  r.metaCID = e.params.metaCID
  r.expiry = e.params.expiry
  r.state = 0
  r.createdAt = e.block.timestamp
  r.updatedAt = e.block.timestamp
  r.save()
}

export function handleRideAccepted(e: RideAccepted): void {
  let id = e.params.rideId.toHex()
  let r = Ride.load(id)
  if (r == null) return
  r.acceptedBy = e.params.driver
  r.updatedAt = e.block.timestamp
  r.save()
}
