variable "sqs_queue_name" {
  type = string
  description = "Map of queue names where key is a name of the queue and value is bool indicating if it's FIFO type."
  default = "queue"
}

variable "sqs_fifo_queue" {
  type = bool
  description = "Indicates if queue should be FIFO"
  default = false
}

variable "sqs_visibility_timeout_seconds" {
  type = number
  description = "Time for which the message can not be consumed by other consumer."
  default = 15 * 60
}

variable "sqs_message_retention_seconds" {
  type = number
  description = "Time for which the message remains in the queue if not deleted by consumer."
  default = 345600 # 4 days
}

variable "sqs_max_message_size" {
  type = number
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it."
  default = 262144 # 256 KiB
}

variable "sqs_delay_seconds" {
  type = number
  description = "The time in seconds that the delivery of all messages in the queue will be delayed."
  default = 0
}

variable "sqs_receive_wait_time_seconds" {
  type = number
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning."
  default = 10
}

variable "sqs_max_receive_count" {
  type = number
  description = "The maximum number of times that a message can be received by consumers. When this value is exceeded for a message the message will be automatically sent to the Dead Letter Queue."
  default = 5
}

variable "sqs_enc_key_deletion_in_days" {
  description = "How often should the encryption key be rotated"
  type = number
  default = 10
}

variable "sqs_enc_key_rotation_enabled" {
  description = "How often should the encryption key be rotated"
  type = bool
  default = true
}