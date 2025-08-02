# backend




<!-- Web socket pattern -->
```mermaid
flowchart LR
  A["WebSocket Request"] --> B["Command Handler Map"]
  B --> C["Command Pattern"]
  C --> D["Repository Methods"]
  D --> E["Database Operations"]
  F["Delete Letter"] --> G["LettersDao.deleteLetter()"]
  G --> H["Database Delete"]
  ```

  <!--  -->
