#[cfg(feature = "impl_from_collab_database")]
use collab_database::error::DatabaseError;

#[cfg(feature = "impl_from_collab_document")]
use collab_document::error::DocumentError;

#[cfg(feature = "impl_from_collab_document")]
use collab_plugins::local_storage::kv::PersistenceError;

use crate::{ErrorCode, FlowyError};

#[cfg(feature = "impl_from_collab_document")]
impl From<PersistenceError> for FlowyError {
  fn from(err: PersistenceError) -> Self {
    match err {
      PersistenceError::UnexpectedEmptyUpdates => FlowyError::new(ErrorCode::RecordNotFound, err),
      #[cfg(not(target_arch = "wasm32"))]
      PersistenceError::RocksdbCorruption(_) => FlowyError::new(ErrorCode::RocksdbCorruption, err),
      #[cfg(not(target_arch = "wasm32"))]
      PersistenceError::RocksdbIOError(_) => FlowyError::new(ErrorCode::RocksdbIOError, err),
      _ => FlowyError::new(ErrorCode::RocksdbInternal, err),
    }
  }
}

#[cfg(feature = "impl_from_collab_database")]
impl From<DatabaseError> for FlowyError {
  fn from(error: DatabaseError) -> Self {
    FlowyError::internal().with_context(error)
  }
}

#[cfg(feature = "impl_from_collab_document")]
impl From<DocumentError> for FlowyError {
  fn from(error: DocumentError) -> Self {
    FlowyError::internal().with_context(error)
  }
}
